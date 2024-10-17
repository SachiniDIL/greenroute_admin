// lib/utils/string_utils.dart

class StringUtils {
  static bool isEmpty(String? text) {
    return text == null || text.trim().isEmpty;
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String truncate(String text, int length) {
    return (text.length <= length) ? text : '${text.substring(0, length)}...';
  }
}
