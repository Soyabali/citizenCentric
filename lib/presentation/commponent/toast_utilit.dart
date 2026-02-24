import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

void showToast(
    String message, {
      ToastGravity gravity = ToastGravity.BOTTOM,
      Color backgroundColor = Colors.black87,
      Color textColor = Colors.white,
      double fontSize = 14.0,
    }) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: gravity,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: fontSize,
  );
}
