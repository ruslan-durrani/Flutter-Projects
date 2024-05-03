import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget getButton(String buttonText,String activeFilter,BuildContext context, Function func){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20),
    child: GestureDetector(
      onTap: ()=>func(buttonText),
      child: Container(

        padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: activeFilter!=buttonText?Colors.black:Colors.black,width: 2),
          borderRadius: BorderRadius.circular(20),
          color: activeFilter!=buttonText?Theme.of(context).colorScheme.secondary:Theme.of(context).colorScheme.primary
        ),
        child: Text(buttonText,style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color:  activeFilter==buttonText?Theme.of(context).colorScheme.secondary:Theme.of(context).colorScheme.primary
        ),),
      ),
    ),
  );
}
