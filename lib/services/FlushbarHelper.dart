import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
class FlushHelper {
  static void flushbarAlert(
      {required BuildContext context,
      required String title,
      required String message,
      int seconds = 3}) { // Added required and default for seconds
    Flushbar(
        icon: Icon(
          title == 'Success' ? Icons.check : Icons.error, // title is now non-nullable
          size: 35,
          color: Colors.white,
        ),
        title: title, // title is now non-nullable
        message: message, // message is now non-nullable
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: title == 'Success' ? Color(0xff5cb85c) : Colors.red, // title is now non-nullable
        duration: Duration(seconds: seconds), // seconds is now non-nullable (has default)
        flushbarStyle: FlushbarStyle.FLOATING,
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.white,
        onTap: (flushbar) {
          flushbar.dismiss();
        }
    ).show(context);
  }
}