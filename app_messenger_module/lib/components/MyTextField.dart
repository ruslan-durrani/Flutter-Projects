import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool isObscure;
  final TextEditingController controller;
  final IconData? trailingIcon;
  const MyTextField({
    super.key,
    required this.hintText,
    required this.isObscure,
    required this.controller,
    this.trailingIcon,

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        autofocus: true,
        controller: controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          prefixIcon: trailingIcon != null?Icon(trailingIcon):null,
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
