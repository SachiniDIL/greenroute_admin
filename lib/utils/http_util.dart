// lib/utils/http_utils.dart

import 'package:http/http.dart' as http;

class HttpUtils {
  static void checkHttpResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("HTTP error: ${response.statusCode}, ${response.body}");
    }
  }

  static Map<String, String> defaultHeaders() {
    return {
      'Content-Type': 'application/json',
    };
  }
}
