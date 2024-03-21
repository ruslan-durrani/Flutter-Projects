import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

Future showVerificationMessage(BuildContext context, UserCredential credentialObject){
  return showDialog(context: context, builder: (context){
    return AlertDialog(
      icon: Icon(Icons.highlight_remove_rounded,color: Colors.red,),
      title: Text("Send verification code"),
      actions: [
        GestureDetector(
          onTap: (){
            credentialObject.user!.sendEmailVerification();
            Navigator.of(context).pop();
          },
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Text("Send Verification Code",style: TextStyle(color: Colors.white),),
          ),
        ),
      ],
    );
  });
}