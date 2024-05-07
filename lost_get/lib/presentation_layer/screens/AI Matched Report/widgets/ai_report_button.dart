import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:provider/provider.dart';

Widget aiButton(
    String title, VoidCallback? handleButton, Color bgColor, Color fgColor) {
  return Consumer(
    builder: (context, ChangeThemeMode value, child) => ElevatedButton(
      onPressed: handleButton,
      style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          disabledBackgroundColor: bgColor.withOpacity(0.5),
          foregroundColor: fgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          )),
      child: Text(
        title,
        style: GoogleFonts.roboto(
          color: Colors.white,
          fontSize: 13.sp,
          fontWeight: value.isDyslexia ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
  );
}
