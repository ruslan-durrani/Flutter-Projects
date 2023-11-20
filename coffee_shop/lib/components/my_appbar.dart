import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget? getAppBar(context,colorScheme,text){
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    automaticallyImplyLeading: false,
    title: Text(text,style: TextStyle(
        fontSize: 18,fontWeight: FontWeight.bold,color: colorScheme.inversePrimary
    ),
    ),
    actions: [
      IconButton(onPressed: (){
        Scaffold.of(context).openDrawer();
      }, icon: Icon(Icons.menu_sharp,color: colorScheme.inversePrimary,))
    ],
  );
}