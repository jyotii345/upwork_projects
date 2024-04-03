import 'package:aggressor_adventures/classes/globals.dart';
import 'package:intl/intl.dart';

class Utils {
  static String getFormattedDate({required DateTime date}) {
    return defaultDateFormat
        .format(DateFormat("yyyy-MM-dd' 'HH:mm:ss.SSS").parse(date.toString()));
  }

  static String getFormattedDateForBackend({required DateTime date}) {
    return defaultDateFormatForBackend
        .format(DateFormat("yyyy-MM-dd' 'HH:mm:ss.SSS").parse(date.toString()));
  }

  static DateTime dateTimeFromString({required String date}) {
    return defaultDateFormatForBackend.parse(date);
  }
}
