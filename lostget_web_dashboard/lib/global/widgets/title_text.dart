import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../../constants/constants.dart';

Widget getTitle(String text){
  return Container(
    child: Text(
      "${text}",
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w700,
        fontSize: 17,
      ),
    ),
  );
}