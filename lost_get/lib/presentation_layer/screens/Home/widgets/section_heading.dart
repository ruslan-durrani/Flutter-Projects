import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget getSectionHeading(title,context, onTap){
  return Padding(
    padding: const EdgeInsets.only(top:20.0,bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
        GestureDetector(
            onTap: BorderRadius.only,
            child: Text("view all",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11,color: Theme.of(context).colorScheme.primary),)),
      ],
    ),
  );
}