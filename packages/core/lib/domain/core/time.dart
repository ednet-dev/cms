part of ednet_core;

/// A utility class for time-related functions.
class Time {
  /// Get the current timestamp
  static int timestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  /// Get the current date without time component
  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Get tomorrow's date
  static DateTime tomorrow() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1);
  }

  /// Get yesterday's date
  static DateTime yesterday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day - 1);
  }

  /// Format a DateTime to a string using the specified format
  static String format(DateTime dateTime, String format) {
    // Simplified formatting for essential patterns
    final String year = dateTime.year.toString();
    final String month = dateTime.month.toString().padLeft(2, '0');
    final String day = dateTime.day.toString().padLeft(2, '0');
    final String hour = dateTime.hour.toString().padLeft(2, '0');
    final String minute = dateTime.minute.toString().padLeft(2, '0');
    final String second = dateTime.second.toString().padLeft(2, '0');

    String result = format;
    result = result.replaceAll('yyyy', year);
    result = result.replaceAll('MM', month);
    result = result.replaceAll('dd', day);
    result = result.replaceAll('HH', hour);
    result = result.replaceAll('mm', minute);
    result = result.replaceAll('ss', second);

    return result;
  }
}
