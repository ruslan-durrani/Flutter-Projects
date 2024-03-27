import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget getSectionHeading(title, context, onTap) {
  return Padding(
    padding: const EdgeInsets.only(top: 20.0, bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        GestureDetector(
            onTap: onTap,
            child: Text(
              "View all",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: Theme.of(context).colorScheme.primary),
            )),
      ],
    ),
  );
}
