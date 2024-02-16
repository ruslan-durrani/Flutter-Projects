import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart' as geocode;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:lost_get/presentation_layer/widgets/toast.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  static const routeName = "/map_screen";

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  late LatLng _initialCenter;
  late LatLng _lastMapPosition;
  final TextEditingController _searchController = TextEditingController();
  final String _apiKey = "AIzaSyByCwDRrNx0LSAdqAQIfRdg57NpVD7G8fY";
  var uuid = const Uuid();
  late final String _sessionToken = uuid.v4();
  List<dynamic> _placeList = [];

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
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request =
          '$baseURL?input=$input&key=$_apiKey&sessiontoken=$_sessionToken';
      var response = await http.get(Uri.parse(request));
      var data = json.decode(response.body);

      print('mydata');
      print(data);

      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      print(e);
    }
  }

  _getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        createToast(description: "Location access denied");
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(locationData.latitude!, locationData.longitude!),
        zoom: 17.0,
      ),
    ));
  }

  Future<void> _goToCurrentLocation() async {
    Location location = Location();
    LocationData currentLocation = await location.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        zoom: 17.0,
      ),
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onCameraIdle() {
    print(
        'Stopped at ${_lastMapPosition.latitude}, ${_lastMapPosition.longitude}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(context, "Drag Map to Select Location"),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialCenter,
              zoom: 11.0,
            ),
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            myLocationEnabled: true,
          ),
          const Center(
            // Marker fixed at the center of the map view
            child: Icon(Icons.location_pin,
                size: 50, color: AppColors.darkPrimaryColor),
          ),
          Positioned(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 10,
                ),
                height: 20.h,
                margin: const EdgeInsets.all(10),
                width: double.infinity,
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
                      height: 100.h,
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
                                fetchLatLongFromPlaceId(
                                    _placeList[index]["place_id"]);
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
            bottom: 100, // Adjust the position as needed
            right: 10,
            child: InkWell(
                onTap: _goToCurrentLocation,
                child: Container(
                  width: 40,
                  height: 40,
                  color: Colors.white.withOpacity(0.8),
                  child: Icon(Icons.my_location,
                      size: 24.0, color: Colors.black.withOpacity(0.65)),
                )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
                onTap: () async {
                  // Fetch the placemarks from the coordinates
                  List<geocode.Placemark> list =
                      await geocode.placemarkFromCoordinates(
                    _lastMapPosition.latitude,
                    _lastMapPosition.longitude,
                  );

                  geocode.Placemark fullAddress = list[0];
                  String address =
                      "${fullAddress.thoroughfare} ${fullAddress.subThoroughfare} ${fullAddress.subLocality}";
                  String city = fullAddress.locality.toString();
                  String country = fullAddress.country.toString();

                  // ignore: use_build_context_synchronously
                  Navigator.pop(context, {
                    "latitude": _lastMapPosition.latitude,
                    "longitude": _lastMapPosition.longitude,
                    "address": address,
                    "city": city,
                    "country": country,
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: AppColors.primaryColor.withOpacity(0.8),
                  ),
                  margin: const EdgeInsets.all(10),
                  width: 30.h,
                  height: 30.h,
                  child: const Icon(
                    Icons.check,
                    size: 35,
                    color: Colors.white,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget? createAppBar(context, String text) {
    return AppBar(
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      centerTitle: true,
      leading: Consumer(
        builder: (context, ChangeThemeMode value, child) {
          ColorFilter? colorFilter = value.isDarkMode()
              ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
              : null;
          return IconButton(
            onPressed: () => Navigator.pop(context),
            icon: SvgPicture.asset(
              'assets/icons/exit_light.svg',
              width: 20,
              height: 20,
              colorFilter: colorFilter,
            ),
          );
        },
      ),
    );
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
                target: LatLng(
                    _lastMapPosition.latitude, _lastMapPosition.longitude),
                zoom: 17.0)));
      }
    }
    return {};
  }
}
