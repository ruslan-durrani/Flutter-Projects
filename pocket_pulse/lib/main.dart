import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pocket_pulse/pages/home_page.dart';
import 'package:pocket_pulse/theme/darkTheme.dart';
import 'package:pocket_pulse/theme/lightTheme.dart';

void main()=>runApp(StartApp());
class StartApp extends StatelessWidget {
  const StartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: HomePage(),
    );
  }
}
