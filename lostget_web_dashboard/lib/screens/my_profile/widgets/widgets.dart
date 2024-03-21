import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../../constants/constants.dart';

setInputDecoration({required String hintText, required String labelText,Widget? suffixIcon,bool? editStatus}) {
  return InputDecoration(
    suffixIcon: suffixIcon,
    labelStyle: TextStyle(color: Colors.black),
    hintStyle: TextStyle(color: Colors.black),
    labelText: labelText,
    hintText: hintText,
    enabled: editStatus??true,
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10)),
    disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10)),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

buttonDecoration(bool isPrimary) {
  return BoxDecoration(
      color: isPrimary?primaryColor:bgColor,
      border: Border.all(width: 1, color: isPrimary?bgColor:primaryColor),
      borderRadius: BorderRadius.circular(10));
}


reusableButton({required String text, required bool isPrimary}) {
  return Container(
    height: 50,
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(
        vertical: appPadding,horizontal: appPadding*2),
    decoration: buttonDecoration(isPrimary),
    child: Text(text,style: TextStyle(color: isPrimary?bgColor:primaryColor),),
  );
}



getPhoneIsoCountry(String phoneNumber) {
  PhoneNumber number =
  PhoneNumber.fromCompleteNumber(completeNumber: (phoneNumber));
  return number.countryISOCode;
}

getPhoneNumber(String phoneNumber) {
  PhoneNumber number =
  PhoneNumber.fromCompleteNumber(completeNumber: (phoneNumber));
  return number.number;
}


Map<String,String> genderImages ={
  "Male":"./assets/images/admin_male_profile_image.png",
  "Female":"./assets/images/admin_female_profile_image.png",
  "Other":"./assets/images/admin_female_profile_image.png",
};