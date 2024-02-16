import 'package:flutter/material.dart';
import 'package:lost_get/common/constants/constant.dart';
import '../../common/global.dart';

class ChangeThemeMode extends ChangeNotifier {
  int _isDarkMode = Global.storageService.getDarkMode() ?? 0;
  int tempDarkMode = Global.storageService.getDarkMode() ?? 0;
  // print("");
  bool _isDylexsia = false;

  int get darkMode => _isDarkMode;

  bool isDarkMode() {
    return _isDarkMode == 0 ? false : true;
  }

  void setDarkMode(int value) {
    tempDarkMode = value;
    notifyListeners();
  }

  void toggleTheme(int value) {
    _isDarkMode = value;

    Global.storageService.setInt(AppConstants.DARK_THEME, value);
    notifyListeners();
  }

  bool get isDyslexia => _isDylexsia;
  void toggleDyslexia(bool value) {
    _isDylexsia = value;
    notifyListeners();
  }

  ThemeMode get currentTheme =>
      _isDarkMode == 1 ? ThemeMode.dark : ThemeMode.light;
}
