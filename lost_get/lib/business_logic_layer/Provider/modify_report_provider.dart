import 'package:flutter/material.dart';

class ModifyReportProvider extends ChangeNotifier {
  List<bool> status = [true, false];
  String initialLocation = "";
  late Map<String, dynamic> locationData;

  List<bool> get getStatus => status;
  String get getInitialLocation => initialLocation;
  Map<String, dynamic> get getLocationData => locationData;

  void setStatus(List<bool> value) {
    status = value;
    notifyListeners();
  }

  void setInitialLocation(String initialLocation) {
    this.initialLocation = initialLocation;
    notifyListeners();
  }

  void setLocationData(Map<String, dynamic> locationData) {
    this.locationData = locationData;
    notifyListeners();
  }
}
