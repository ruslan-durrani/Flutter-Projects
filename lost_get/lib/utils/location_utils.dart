  import 'dart:math';
  import 'package:location/location.dart' as loc;
  import 'package:location/location.dart';
  import 'package:lost_get/presentation_layer/widgets/toast.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:geocoding/geocoding.dart';
  import 'package:geolocator/geolocator.dart';
  import 'package:lost_get/models/report_item.dart';

  class LocationUtils {
    static const double significantDistance = 1.0; // Threshold for significant location change in kilometers
    double lastLatitude=0;
    double lastLongitude=0;
    double radiusKm;
    List<ReportItemModel> itemsNearby = [];
    loc.Location location = loc.Location();  // Using the alias to specify the Location class from the location package

    LocationUtils(this.radiusKm);

    Future<void> getCurrentLocationAndUpdate() async {
      loc.Location location = loc.Location();
      bool serviceEnabled;
      PermissionStatus permissionGranted;

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



      // Obtain the current location
      LocationData locationData = await location.getLocation();
      lastLatitude = locationData.latitude!;
      lastLongitude = locationData.longitude!;
      print('Updated Location: Latitude $lastLatitude, Longitude $lastLongitude');

      // Optionally, trigger nearby reports query or any other action
      itemsNearby = await queryNearbyReports(33.66659162846188, 73.07104904204607, radiusKm);
      // queryNearbyReports(lastLatitude, lastLongitude, radiusKm);
      //latitude: 33.66659162846188, longitude: 73.07104904204607
    }

    static double degreesToRadians(double degrees) {
      return degrees * pi / 180;
    }


    static Map<String, double> calculateBounds(double latitude, double longitude, double distance) {
      double latChange = distance / 111; // Roughly 111km per latitude degree
      double lonChange = distance / (111 * cos(degreesToRadians(latitude))); // Adjust longitude by cos(latitude)
      return {
        'minLat': latitude - latChange,
        'maxLat': latitude + latChange,
        'minLon': longitude - lonChange,
        'maxLon': longitude + lonChange
      };
    }

    Future<List<ReportItemModel>> queryNearbyReports(double currentLatitude, double currentLongitude, double radius) async {

      var bounds = calculateBounds(currentLatitude, currentLongitude, radius);
      final querySnapshot = await FirebaseFirestore.instance
          .collection('reportItems')
          .where('coordinates.Latitude', isGreaterThanOrEqualTo: bounds['minLat'])
          .where('coordinates.Latitude', isLessThanOrEqualTo: bounds['maxLat'])
          .where('coordinates.Longitude', isGreaterThanOrEqualTo: bounds['minLon'])
          .where('coordinates.Longitude', isLessThanOrEqualTo: bounds['maxLon'])
          .limit(50)
          .get();

      // Filter the results in Dart
      print(querySnapshot.size);
      return querySnapshot.docs
          .map((doc) => ReportItemModel.fromSnapshot(doc))
          .toList();

    }
  }
