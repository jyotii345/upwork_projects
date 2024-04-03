import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class Toaster {
  static showSuccess(String? message) {
    if (message != null && message.isNotEmpty) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 15,
      );
    }
  }

  static showError(String? message) {
    if (message != null && message.isNotEmpty) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 15);
    }
  }

  static showInfo(String? message) {
    if (message != null && message.isNotEmpty) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black,
          fontSize: 15);
    }
  }
}
