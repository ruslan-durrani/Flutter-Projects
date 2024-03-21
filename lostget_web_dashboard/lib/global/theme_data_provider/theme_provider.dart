

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AppTheme { light, dark }

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = ThemeData.light();

  ThemeData get themeData => _themeData;

  setTheme(AppTheme theme) {
    if (theme == AppTheme.light) {
      _themeData = ThemeData.light();
    } else {
      _themeData = ThemeData.dark();
    }
    notifyListeners();
  }
}
