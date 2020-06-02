import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
class FlushHelper {
  static void flushbarAlert({BuildContext context, String title, String message, int seconds}) {
    Flushbar(
        icon: Icon(
          title == 'Success' ? Icons.check : Icons.error,
          size: 35,
          color: Colors.white,
        ),
        title: title,
        message: message,
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: title == 'Success' ? Color(0xff5cb85c) : Colors.red,
        duration: Duration(seconds: seconds),
        flushbarStyle: FlushbarStyle.FLOATING,
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.white,
        onTap: (flushbar) {
          flushbar.dismiss();
        }
    ).show(context);
  }
}