import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc;
import 'package:uuid/uuid.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  static const routeName = "/map_screen";

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  late LatLng _initialCenter;
  late LatLng _lastMapPosition;
  final TextEditingController _searchController = TextEditingController();
  final String _apiKey = "AIzaSyAg_UlGVyl_cE_NZT6gmaNjQqir_AJrWoI";
  final uuid = const Uuid();
  late final String _sessionToken = uuid.v4();
  List<dynamic> _placeList = [];
  String addressDescriptionFromPlaceId = "";

  @override
  void initState() {
    super.initState();
    _initialCenter = const LatLng(45.521563, -122.677433);
    _lastMapPosition = _initialCenter;
    _getCurrentLocation();
    _searchController.addListener(() {
      getSuggestion(_searchController.text);
    });
  }

  void getSuggestion(String input) async {
    try {
      String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request = '$baseURL?input=$input&key=$_apiKey&sessiontoken=$_sessionToken';
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
        });
      } else {
        throw Exception('Failed to load predictions: ${response.body}');
      }
    } catch (e) {
      _showToast('Error getting suggestions: $e');
      print('Error getting suggestions: $e');
    }
  }


  Future<void> _getCurrentLocation() async {
    loc.Location location = loc.Location();
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;
    loc.LocationData locationData;

    try {
      // Check if location services are enabled
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          // Handle disabled location services
          _showToast("Location services are disabled");
          return;
        }
      }

      // Check and request permission
      permissionGranted = await location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          _showToast("Location permission denied");
          return;
        }
      }

      // Get current location
      locationData = await location.getLocation();

      // Animate the camera to the current location if mapController is initialized
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(locationData.latitude!, locationData.longitude!),
          zoom: 17.0,
        ),
      ));
    } catch (e) {
      // Handle any errors that may have occurred
      _showToast("Error occurred while fetching location: $e");
    }
  }

  Future<void> _goToCurrentLocation() async {
    loc.Location location = loc.Location();
    loc.LocationData currentLocation = await location.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        zoom: 17.0,
      ),
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onCameraIdle() {
    print('Stopped at ${_lastMapPosition.latitude}, ${_lastMapPosition.longitude}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(context, "Drag Map to Select Location"),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialCenter,
              zoom: 11.0,
            ),
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            myLocationEnabled: true,
          ),
          Center(
            child: Icon(Icons.location_pin, size: 50, color: Theme.of(context).primaryColor),
          ),
          Positioned(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment:Alignment.center,
                    padding: const EdgeInsets.only(left: 10),
                    height: 70,
                    margin: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width *.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search places with name....',
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () => {},
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.cancel),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                            : null,
                      ),
                    ),
                  ),
                  _placeList.isNotEmpty
                      ? Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _placeList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              fetchLatLongFromPlaceId(_placeList[index]["place_id"]);
                              addressDescriptionFromPlaceId = "";
                              for (var place in _placeList) {
                                if (place["place_id"].toString() == _placeList[index]["place_id"]) {
                                  var formatAddress = place["description"].toString().split(",");
                                  for (int i = 0; i < formatAddress.length; i++) {
                                    if (formatAddress[i + 1].toString().contains("Pakistan")) {
                                      break;
                                    } else {
                                      addressDescriptionFromPlaceId += formatAddress[i];
                                      if (!formatAddress[i + 2].toString().contains("Pakistan")) {
                                        addressDescriptionFromPlaceId += ", ";
                                      }
                                    }
                                  }
                                }
                              }

                              setState(() {
                                _placeList.clear();
                                _searchController.clear();
                              });
                            },
                            child: ListTile(
                              title: Text(_placeList[index]["description"]),
                            ),
                          );
                        }),
                  )
                      : Container(),
                ]),
          ),
          Positioned(
            bottom: 100,
            right: 10,
            child: InkWell(
              onTap: _goToCurrentLocation,
              child: Container(
                width: 40,
                height: 40,
                color: Colors.white.withOpacity(0.8),
                child: Icon(Icons.my_location, size: 24.0, color: Colors.black.withOpacity(0.65)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget? _createAppBar(context, String text) {
    return AppBar(
      title: Text(text, style: Theme.of(context).textTheme.bodyMedium),
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
      actions: [
        InkWell(
          onTap: _onSelectLocation,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text("Select Location"),
          ),
        ),
      ],
    );
  }

  void _onSelectLocation() async {
    List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(
      _lastMapPosition.latitude,
      _lastMapPosition.longitude,
    );

    var fullAddress = placemarks.isNotEmpty ? placemarks[0] : null;

    String address =
        "${fullAddress?.thoroughfare ?? ""} ${fullAddress?.subThoroughfare ?? ""} ${fullAddress?.subLocality ?? ""}";
    String city = fullAddress?.locality ?? "";
    String country = fullAddress?.country ?? "";

    Navigator.pop(context, {
      "latitude": _lastMapPosition.latitude,
      "longitude": _lastMapPosition.longitude,
      "address": fullAddress?.thoroughfare?.isEmpty ?? true
          ? addressDescriptionFromPlaceId
          : address,
      "city": city,
      "country": country,
    });
  }

  Future<Map<String, dynamic>> fetchLatLongFromPlaceId(String placeId) async {
    final Uri requestUri = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$_apiKey',
    );

    final response = await http.get(requestUri);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'OK') {
        _lastMapPosition = LatLng(
            jsonResponse['result']['geometry']['location']['lat'],
            jsonResponse['result']['geometry']['location']['lng']);

        mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(_lastMapPosition.latitude, _lastMapPosition.longitude),
                zoom: 17.0)));
      }
    }
    return {};
  }

  void _showToast(String message) {
    print(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
