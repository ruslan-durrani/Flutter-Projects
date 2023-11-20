import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Stack getMyCoffeeAddButton(context,colorScheme,onAddCoffeePressed){
  return Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: colorScheme.inversePrimary.withOpacity(.5),width: 3),
        ),
        child: FloatingActionButton(
          backgroundColor: colorScheme.background,
          onPressed: onAddCoffeePressed,
          child: Icon(Icons.coffee,color: colorScheme.inversePrimary,),
        ),
      ),
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: colorScheme.inversePrimary,
          ),
          child: Icon(Icons.add,size: 20,color: colorScheme.primary,),
        ),
      ),
    ],
  );;
}