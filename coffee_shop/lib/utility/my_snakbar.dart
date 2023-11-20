import 'package:flutter/material.dart';

void showSnackBar(BuildContext context,String message){
  var colorScheme = Theme.of(context).colorScheme;
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: colorScheme.inversePrimary),),
      backgroundColor: colorScheme.primary,
      dismissDirection: DismissDirection.horizontal,
      duration: Duration(seconds: 1),
    ),
  );
}