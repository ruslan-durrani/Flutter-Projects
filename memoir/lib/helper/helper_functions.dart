import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Display Message To user
void displayMessageToUser(BuildContext context, String message){
  // showDialog(context: context, builder: (context)=>AlertDialog(
  //   title: Text(message),
  // ));
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}