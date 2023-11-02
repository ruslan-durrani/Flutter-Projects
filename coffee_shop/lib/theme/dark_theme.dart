import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
        background: Colors.brown.shade900,
        primary: Colors.brown.shade800,
        secondary: Colors.brown.shade700,
        inversePrimary: Colors.brown.shade100
    ),
    textTheme: ThemeData.dark().textTheme.apply(
      bodyColor: Colors.brown[800],
      displayColor: Colors.white,
    )
);
