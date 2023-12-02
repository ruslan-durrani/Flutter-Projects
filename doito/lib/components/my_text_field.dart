import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  TextEditingController controller;
  String hint;
  bool obscureText;
  bool isMultiLine = false;
  TextInputType inputType = TextInputType.text;
  MyTextField({Key? key,this.inputType = TextInputType.text,this.isMultiLine = false, required this.controller, required this.hint, required this.obscureText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: inputType,
      style: TextStyle(
        fontSize: 15,
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
      maxLines: isMultiLine?5:1,
      decoration: InputDecoration(

        hintStyle: TextStyle(fontSize: 15,color: colorScheme.inversePrimary),
        hintText: hint,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.inversePrimary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.secondary),
        ),
      ),
    );
  }
}
