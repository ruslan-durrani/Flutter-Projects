import 'package:flutter/material.dart';

import 'package:mental_healthapp/shared/constants/colors.dart';
import 'package:mental_healthapp/shared/constants/sizes.dart';

class ETextFormFieldTheme {
  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: EColors.darkGrey,
    suffixIconColor: EColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: Esizes.inputFieldHeight),
    labelStyle: const TextStyle()
        .copyWith(fontSize: Esizes.fontMd, color: EColors.black),
    hintStyle: const TextStyle()
        .copyWith(fontSize: Esizes.fontSm, color: EColors.darkGrey),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle:
        const TextStyle().copyWith(color: EColors.black.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(Esizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: EColors.grey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(Esizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: EColors.grey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(Esizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: EColors.dark),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(Esizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: EColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(Esizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: EColors.warning),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: EColors.darkGrey,
    suffixIconColor: EColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: Esizes.inputFieldHeight),
    labelStyle: const TextStyle()
        .copyWith(fontSize: Esizes.fontMd, color: EColors.white),
    hintStyle: const TextStyle()
        .copyWith(fontSize: Esizes.fontSm, color: EColors.white),
    floatingLabelStyle:
        const TextStyle().copyWith(color: EColors.white.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(Esizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: EColors.darkGrey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(Esizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: EColors.darkGrey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(Esizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: EColors.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(Esizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: EColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(Esizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: EColors.warning),
    ),
  );
}
