import 'package:flutter/material.dart';

void showSnackBar(BuildContext context){
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item addedd successfully",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),backgroundColor: Theme.of(context).colorScheme.primary,),);
}