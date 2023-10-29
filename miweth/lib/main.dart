import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miweth/pages/weather_page.dart';
import 'package:miweth/theme/darkTheme.dart';
import 'package:miweth/theme/lightTheme.dart';

void main()=>runApp(StartApp());

class StartApp extends StatelessWidget {
  const StartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: WeatherPage(),
    );
  }
}
