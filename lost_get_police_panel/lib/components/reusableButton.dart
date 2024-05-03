import 'package:flutter/material.dart';
import 'package:lost_get_police_panel/theme.dart';

reusableButton({required String text, required bool isPrimary}) {
  final double appPadding = 28;
  print(themeData.colorScheme.secondary);
  return Container(
    // height: 50,
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(
        vertical: appPadding,horizontal: appPadding*2),
    decoration: buttonDecoration(isPrimary),
    child: Text(text,style: TextStyle(color: isPrimary?themeData.colorScheme.secondary:themeData.colorScheme.primary),),
  );
}

buttonDecoration(bool isPrimary) {
  return BoxDecoration(
      color: isPrimary?themeData.colorScheme.primary:themeData.colorScheme.secondary,
      border: Border.all(width: 1, color: isPrimary?themeData.colorScheme.secondary:themeData.colorScheme.primary),
      borderRadius: BorderRadius.circular(10));
}
