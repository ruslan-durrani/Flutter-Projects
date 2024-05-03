import 'package:flutter/material.dart';
import 'package:lost_get_police_panel/theme.dart';

Widget buildTextField(Icon preFixIcon, String hintText,  onChange, {bool? isObscure,Widget? suffixIcon}){
  final double appPadding = 28;
  return Padding(
    padding:  EdgeInsets.symmetric(horizontal: appPadding),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Spacer(),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: appPadding - 5,
                vertical: appPadding),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: themeData.primaryColor),
                borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                preFixIcon,
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    height: appPadding,
                    child: TextField(
                      onChanged: onChange,
                      keyboardType: TextInputType.text,
                      obscureText: isObscure??false,
                      decoration: InputDecoration(
                          suffixIcon: suffixIcon,
                          hintText: hintText,
                          // hintText: "Enter your email",
                          enabledBorder: OutlineInputBorder(
                            gapPadding: 0,
                            borderSide: BorderSide.none,
                          ),
                          disabledBorder: OutlineInputBorder(
                            gapPadding: 0,
                            borderSide: BorderSide.none,
                          ),
                          border: InputBorder.none
                      ),

                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}