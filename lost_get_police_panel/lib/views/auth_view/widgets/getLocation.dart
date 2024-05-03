import 'dart:html';

import 'package:geolocator/geolocator.dart';
import 'dart:html';
import 'dart:html';

Future<Geoposition> getCurrentLocation() async {
  try {
    // Request location permission
    if (window.navigator.geolocation != null) {
      // Get current position
      Geoposition position = await window.navigator.geolocation.getCurrentPosition();
      return position;
    } else {
      throw Exception('Geolocation is not supported by this browser.');
    }
  } catch (e) {
    print('Error getting location: $e');
    throw e;
  }
}
