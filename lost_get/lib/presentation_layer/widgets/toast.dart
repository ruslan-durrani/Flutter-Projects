import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lost_get/common/constants/colors.dart';

createToast(
    {required description,
    Color backgroundColor = AppColors.primaryColor,
    Color textColor = Colors.white}) {
  Fluttertoast.showToast(
    msg: description,
    gravity: ToastGravity.BOTTOM,
    toastLength: Toast.LENGTH_SHORT,
    textColor: textColor,
    backgroundColor: backgroundColor,
    timeInSecForIosWeb: 2,
    fontSize: 14.sp,
    
  );
}
