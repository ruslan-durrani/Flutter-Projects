import 'package:flutter/material.dart';


// ThemeData lightTheme = ThemeData(
//     brightness: Brightness.light,
//     colorScheme: ColorScheme.light(
//         background: Colors.blue.shade200,
//         primary: Colors.blue.shade400,
//         secondary: Colors.blue.shade400,
//         inversePrimary: Colors.blue.shade800
//     ),
//     textTheme: ThemeData.light().textTheme.apply(
//       bodyColor: Colors.blue[800],
//       displayColor: Colors.black,
//     )
// );
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
      background: Colors.orange.shade200,
    primary: Colors.orange.shade400,
    secondary: Colors.orange.shade400,
    inversePrimary: Colors.orange.shade800
  ),
  textTheme: ThemeData.light().textTheme.apply(
    bodyColor: Colors.orange[800],
    displayColor: Colors.black,
  )
);