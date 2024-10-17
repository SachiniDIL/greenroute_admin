// lib/utils/date_time_utils.dart

class DateTimeUtils {
  static String formatDateTime(DateTime dateTime) {
    return "${dateTime.day}-${dateTime.month}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}";
  }

  static DateTime parseDateString(String dateString) {
    return DateTime.parse(dateString);
  }

  static String formatDateOnly(DateTime dateTime) {
    return "${dateTime.day}-${dateTime.month}-${dateTime.year}";
  }

  static String formatTimeOnly(DateTime dateTime) {
    return "${dateTime.hour}:${dateTime.minute}";
  }
}
