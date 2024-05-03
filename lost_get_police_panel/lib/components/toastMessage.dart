import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> toasterFlutter(String msg){
  return Fluttertoast.showToast(
      timeInSecForIosWeb: 2,
      msg: msg,
      gravity: ToastGravity.TOP);
}