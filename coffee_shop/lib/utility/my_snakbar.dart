import 'package:flutter/material.dart';

void showSnackBar(BuildContext context,String message){
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message,style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),backgroundColor: Theme.of(context).colorScheme.primary,),);
}