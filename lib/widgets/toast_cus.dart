import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToastCusCenter(String msg, {int? duration}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      webShowClose: false,
      backgroundColor: Colors.redAccent,
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
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 15);
}
