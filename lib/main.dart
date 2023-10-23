import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(const StartApp());
class StartApp extends StatelessWidget {
  const StartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: SafeArea(child: Scaffold(
        body: Center(child: Text("Memoir Maple"),),
      ),),
    );
  }
}
