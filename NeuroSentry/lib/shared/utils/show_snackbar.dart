import 'package:flutter/material.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';

void showSnackBar({
  required BuildContext context,
  required String content,
  bool isError = false,
  Color backgroundColor = EColors.primarybg,
  Duration duration = const Duration(seconds: 3),
  SnackBarAction? action,
  SnackBarAnimation? animation = SnackBarAnimation.slide,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(

      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isError?Icon(Icons.error,color: Colors.red,):Icon(Icons.celebration,color: Colors.green,),
          Text(
            content,
            style: TextStyle(color: EColors.textPrimary),
          ),
        ],
      ),
      backgroundColor:backgroundColor,
      duration: duration,
      action: action,

      behavior: animation == SnackBarAnimation.slide ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
      margin: animation == SnackBarAnimation.slide ? EdgeInsets.all(10) : null,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
    ),
  );
}

// Enum to specify the animation type
enum SnackBarAnimation { slide, fixed }
