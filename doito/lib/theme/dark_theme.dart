import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
        background: Colors.orange.shade200,
        primary: Colors.orange.shade800,
        secondary: Colors.orange.shade700,
        inversePrimary: Colors.orange.shade100
    ),
    textTheme: ThemeData.dark().textTheme.apply(
      bodyColor: Colors.orange[800],
      displayColor: Colors.white,
    )
);
