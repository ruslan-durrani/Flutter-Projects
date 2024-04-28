import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ruslanbabar/theme.dart';
import 'views/Home/home_view.dart';
void main()=>runApp(StartApp());
class StartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RuslanB',
      theme: themeData,
      darkTheme: darkThemeData,
      themeMode: ThemeMode.system,
      home: HomeView(),
    );
  }
}
