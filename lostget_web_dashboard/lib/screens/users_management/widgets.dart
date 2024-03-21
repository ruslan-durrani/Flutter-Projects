import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/constants.dart';

Widget callEditButton() {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(4),
        color: primaryColor.withOpacity(.1),
        border: Border.all(
            width: 1, color: primaryColor)),
    child: Row(
      children: [
        Text(
          "Edit Profile",
          style: TextStyle(
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 5,
        ),
        SvgPicture.asset(
            "./assets/icons/edit.svg")
      ],
    ),
  );
}