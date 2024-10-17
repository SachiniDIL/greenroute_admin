import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl = "https://greenroute-7251d-default-rtdb.firebaseio.com";

  // Method to handle GET requests
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Returns the decoded JSON data
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Method to handle POST requests
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body); // Returns the decoded JSON data
    } else {
      throw Exception('Failed to post data');
    }
  }

  // Method to handle PUT requests
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Returns the decoded JSON data
    } else {
      throw Exception('Failed to update data');
    }
  }

  // Method to handle PATCH requests
  Future<dynamic> patch(String endpoint, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Returns the decoded JSON data
    } else {
      throw Exception('Failed to update data with PATCH');
    }
  }

  // Method to handle DELETE requests
  Future<void> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl/$endpoint'));

    if (response.statusCode == 200 || response.statusCode == 204) {
      // Successfully deleted, no return value needed
      return;
    } else {
      throw Exception('Failed to delete data');
    }
  }
}
