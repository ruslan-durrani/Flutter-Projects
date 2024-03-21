import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
Widget buildButton(String buttonText, onTap, bool isFill){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: appPadding),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Spacer(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: InkWell(
              onTap: onTap,
              child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: appPadding),
                  decoration: BoxDecoration(
                      color: isFill?primaryColor:bgColor,
                      border: Border.all(width: 1, color: textColor),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(child: Text(buttonText,style: TextStyle(fontWeight: FontWeight.normal,fontSize:18,color: isFill?bgColor:textColor),),)),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildTextField(Icon preFixIcon, String hintText,  onChange, {bool? isObscure,Widget? suffixIcon}){
  return Padding(
  padding: const EdgeInsets.symmetric(horizontal: appPadding),
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
              border: Border.all(width: 1, color: textColor),
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

Widget authOptionText(){
  return Padding(
    padding:
    const EdgeInsets.only(left: appPadding,right:appPadding,bottom: appPadding),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Spacer(),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Divider(
                    height: 1,
                    color: grey,
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: appPadding),
                child: Text(
                  "or continue with email",
                ),
              ),
              Expanded(
                  child: Divider(
                    height: 1,
                    color: grey,
                  )),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget GoogleSignInOption(){
  return Padding(
    padding: const EdgeInsets.all(appPadding),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: (){

            },
            child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: appPadding-2),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: textColor),
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage(
                          "./assets/images/google.png"),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Continue with Google",
                    ),
                  ],
                )),
          ),
        ),
      ],
    ),
  );
}
