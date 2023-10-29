import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
        background: Colors.grey.shade900,
        primary: Colors.grey.shade800,
        secondary: Colors.grey.shade700,
        inversePrimary: Colors.grey.shade300
    ),
    textTheme: ThemeData.dark().textTheme.apply(
      bodyColor: Colors.grey[800],
      displayColor: Colors.white,
    )
);