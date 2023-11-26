import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

getPopulatedLocalImages(size,file,removeFunction,colorScheme){
  return Padding(
    padding: const EdgeInsets.all(3.0),
    child: Stack(
      children: [
        Container(
          decoration:BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          height: size.width * .3,
          width: size.width * .3,
          margin: const EdgeInsets.all(5),
          child: Image.file(File(file.path),fit: BoxFit.fill,),
        ),
        Positioned(
          bottom:8,right:12,
          child: GestureDetector(
            onTap: removeFunction,
            child: CircleAvatar(
              radius: 12,
              backgroundColor: colorScheme.secondary,
              child: Icon(
                Icons.cancel,color: colorScheme.inversePrimary,),
            ),
          ),
        )
      ],
    ),
  );
}