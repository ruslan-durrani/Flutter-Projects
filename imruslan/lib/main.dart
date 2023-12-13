import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imruslan/views/home_page.dart';

void main() => runApp(StartApp());
class StartApp extends StatelessWidget {
  const StartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
