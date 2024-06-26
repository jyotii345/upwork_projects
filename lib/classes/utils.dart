import 'package:aggressor_adventures/classes/globals.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../user_interface_pages/main_page.dart';

class Utils {
  static String getFormattedDate({required DateTime date}) {
    return defaultDateFormat
        .format(DateFormat("yyyy-MM-dd' 'HH:mm:ss.SSS").parse(date.toString()));
  }

  static String getFormattedDateWithTime({required DateTime date}) {
    return DateFormat("MMMM d, y hh:mm aaa")
        .format(DateFormat("yyyy-MM-dd' 'HH:mm:ss.SSS").parse(date.toString()));
  }

  static String getFormattedDateForBackend({required DateTime date}) {
    return defaultDateFormatForBackend
        .format(DateFormat("yyyy-MM-dd' 'HH:mm:ss.SSS").parse(date.toString()));
  }

  static String getFormattedDateForTravelInformation({required DateTime date}) {
    return defaultDateFormatForTravelPost.format(date);
  }

  static DateTime dateTimeFromString({required String date}) {
    return defaultDateFormatForBackend.parse(date);
  }

  static Widget getBulletPointText(
      {required String text, TextStyle? textStyle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "• ",
          style: textStyle,
        ),
        Expanded(
          child: Text(
            text,
            style: textStyle,
          ),
        ),
      ],
    );
  }

  static void redirectToHomePage({required BuildContext context}) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(),
      ),
      (route) => false,
    );
  }
}
