import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String buttonText;
  final Function()? onTap;
  MyButton({
    super.key,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.primary,width: 0),
          borderRadius: BorderRadius.circular(10),
          color: colorScheme.secondary,
        ),
        child: Text(buttonText),
      ),
    );
  }
}
