import 'package:flutter/material.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';
import 'package:mental_healthapp/shared/constants/sizes.dart';

class EElevatedButtonTheme {
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: EColors.light,
      backgroundColor: EColors.primaryColor,
      disabledForegroundColor: EColors.darkGrey,
      disabledBackgroundColor: EColors.buttonDisabled,
      side: const BorderSide(color: EColors.primarybg),
      padding: const EdgeInsets.symmetric(vertical: Esizes.buttonHeight),
      textStyle: const TextStyle(
        fontSize: 16,
        color: EColors.textWhite,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Esizes.buttonRadius),
      ),
    ),
  );
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: EColors.light,
      backgroundColor: EColors.primarybg,
      disabledForegroundColor: EColors.darkGrey,
      disabledBackgroundColor: EColors.darkerGrey,
      side: const BorderSide(color: EColors.primarybg),
      padding: const EdgeInsets.symmetric(vertical: Esizes.buttonHeight),
      textStyle: const TextStyle(
          fontSize: 16, color: EColors.textWhite, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Esizes.buttonRadius)),
    ),
  );
}
