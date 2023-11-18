import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  String hintText;
  TextEditingController controller;
  bool obscureText;
  MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
          fontSize: 15,
          color: Theme.of(context).colorScheme.inversePrimary
      ),
      decoration: InputDecoration(
        hintStyle: TextStyle(fontSize: 15),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8)
        )
      ),
    );
  }
}
