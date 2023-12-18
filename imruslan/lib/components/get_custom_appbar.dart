import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controllers/responsive_service.dart';
import 'get_custom_button.dart';

PreferredSizeWidget GetCustomAppbar(BuildContext context){
  var colorScheme = Theme.of(context).colorScheme;
  return !Responsive.isDesktop(context)?
  AppBar(
    backgroundColor: colorScheme.background,
    title: Text("Ruslan.",style: TextStyle(fontWeight: FontWeight.bold),),
  ):
  PreferredSize(
      preferredSize: Size(double.maxFinite, MediaQuery.of(context).size.height *.1),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 115),
        height: double.maxFinite,
        // color: colorScheme.secondary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Ruslan.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Row(
              children: [
                Text(
                  "About",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15
                  ),
                ),
                SizedBox(width: 20,),
                Text(
                  "Services",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15
                  ),
                ),
                SizedBox(width: 20,),
                Text(
                  "Portfolio",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15
                  ),
                ),
              ],
            ),
            GetCustomButton()
          ],
        ),
      ),
  );
}