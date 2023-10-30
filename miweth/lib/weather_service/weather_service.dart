import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';

import '../models/weather_model.dart';
class WeatherService{
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService({required this.apiKey});
  Future<Weather> getWeather({required String cityName}) async {
    final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey'));
    print(response.body);
    if(response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body));
    }
    else{
      throw Exception("Fail to load weather data");
    }
  }
  getCurrentLocation() async {
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if(locationPermission == LocationPermission.denied){
      locationPermission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placeMarks = await placemarkFromCoordinates(position.latitude,position.longitude);
    String? city = placeMarks[0].locality;
    return city;
  }
}