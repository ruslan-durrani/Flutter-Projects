import 'package:flutter/material.dart';
import 'package:mental_healthapp/theme/custom_themes/appbartheme.dart';
import 'package:mental_healthapp/theme/custom_themes/elevatedbuttontheme.dart';
import 'package:mental_healthapp/theme/custom_themes/text_theme.dart';
import 'package:mental_healthapp/theme/custom_themes/txtfieldtheme.dart';

class EAppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: Colors.white,
    primaryColor: const Color(0xff0F349C),
    brightness: Brightness.light,
    textTheme: EAppTxtTheme.lightTextTheme,
    appBarTheme: EAppBarTheme.lightAppBarTheme,
    // checkboxTheme: ECheckBoxTheme.lightMode,
    elevatedButtonTheme: EElevatedButtonTheme.lightElevatedButtonTheme,
    inputDecorationTheme: ETextFormFieldTheme.lightInputDecorationTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: Colors.black,
    primaryColor: const Color(0xff0F349C),
    brightness: Brightness.dark,
    textTheme: EAppTxtTheme.darkTextTheme,
    appBarTheme: EAppBarTheme.darkAppbarTheme,
    //checkboxTheme: ECheckBoxTheme.darkMode,
    elevatedButtonTheme: EElevatedButtonTheme.darkElevatedButtonTheme,
    inputDecorationTheme: ETextFormFieldTheme.darkInputDecorationTheme,
  );
}
