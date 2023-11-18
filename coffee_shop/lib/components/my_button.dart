import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  String buttonText;
   MyButton({super.key,required this.buttonText});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(10)
      ),
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Text(buttonText,style: TextStyle(color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.bold,fontSize: 17),),
    );
  }
}
