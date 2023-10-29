import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyBackButton extends StatelessWidget {
  Function() backPress;
  MyBackButton({super.key,required this.backPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: backPress,
      child: Container(
        padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle
            // borderRadius: BorderRadius.circular(20)
          ),
          child: Icon(Icons.arrow_back,color: Theme.of(context).colorScheme.inversePrimary,)),
    );
  }
}
