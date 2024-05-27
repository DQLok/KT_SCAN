import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:techable/constants/colors_app.dart';

showToastCusCenter(String msg, {int? duration}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      webShowClose: false,
      backgroundColor: ColorsApp.primary,
      textColor: Colors.white,
      fontSize: 15);
}

showToastCusBottom(String msg, {int? duration}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      webShowClose: false,
      backgroundColor: ColorsApp.primary,
      textColor: Colors.white,
      fontSize: 15);
}
