// lib/utils/error_utils.dart

class ErrorUtils {
  static String getErrorMessage(Object error) {
    if (error is Exception) {
      return error.toString();
    } else if (error is String) {
      return error;
    } else {
      return "An unexpected error occurred.";
    }
  }
}
