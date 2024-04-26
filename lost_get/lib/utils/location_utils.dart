import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lost_get/models/report_item.dart';
import 'package:lost_get/presentation_layer/screens/Home/widgets/reportedItemCard.dart';

class LocationUtils {
  static const double significantDistance = 1.0; // Threshold for significant location change in kilometers
  double lastLatitude;
  double lastLongitude;
  double radiusKm;
  List<ReportItemModel> itemsNearby = [];

  LocationUtils(this.lastLatitude, this.lastLongitude,this.radiusKm) {
    LocationSettings locationSettings = LocationSettings(distanceFilter: 10); // 10 meters
    Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      double distanceMoved = Geolocator.distanceBetween(
          lastLatitude, lastLongitude, position.latitude, position.longitude);
      if (distanceMoved >= significantDistance * 1000) {
        lastLatitude = position.latitude;
        lastLongitude = position.longitude;
        queryNearbyReports(lastLatitude, lastLongitude, radiusKm); // Query within 10km radius, adjust as needed
      }
    });
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
    var query = FirebaseFirestore.instance.collection('reportItems')
        .where('coordinates.Latitude', isGreaterThanOrEqualTo: bounds['minLat'])
        .where('coordinates.Latitude', isLessThanOrEqualTo: bounds['maxLat'])
        .where('coordinates.Longitude', isGreaterThanOrEqualTo: bounds['minLon'])
        .where('coordinates.Longitude', isLessThanOrEqualTo: bounds['maxLon']);

    query.get().then((snapshot) {

      for (var doc in snapshot.docs) {
        ReportItemModel item = ReportItemModel.fromSnapshot(doc);
        itemsNearby.add(item);
      }
    });
    return itemsNearby;
  }
}
