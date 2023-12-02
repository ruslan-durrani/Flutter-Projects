
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  String buttonText;
  bool isPrimary = true;
  MyButton({super.key,required this.buttonText, this.isPrimary = true});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: isPrimary?colorScheme.inversePrimary:colorScheme.secondary,
          borderRadius: BorderRadius.circular(10)
      ),
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Text(buttonText,style: TextStyle(color: isPrimary?colorScheme.secondary:colorScheme.inversePrimary,fontWeight: FontWeight.bold,fontSize: 17),),
    );
  }
}
