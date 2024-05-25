import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

Widget circularProgressIndicator(){
  return Positioned.fill(
    child: Container(
      color: EColors.primaryColor.withOpacity(.2),  // Shadowed background
      child: Center(
        child: CircularProgressIndicator(),  // Loading indicator
      ),
    ),
  );
}