import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Display Message To user
void displayMessageToUser(BuildContext context, String message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message,style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),backgroundColor: Theme.of(context).colorScheme.secondary,));
}