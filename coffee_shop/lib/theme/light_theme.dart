import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.brown.shade100,
    primary: Colors.brown.shade200,
    secondary: Colors.brown.shade400,
    inversePrimary: Colors.brown.shade800
  ),
  textTheme: ThemeData.light().textTheme.apply(
    bodyColor: Colors.brown[800],
    displayColor: Colors.black,
  )
);