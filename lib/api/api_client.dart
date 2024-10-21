import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  // Private constructor to prevent instantiation
  ApiClient._();

  // Static field to hold the single instance
  static final ApiClient _instance = ApiClient._();

  // Factory constructor to return the same instance every time
  factory ApiClient() {
    return _instance;
  }

  final String baseUrl = "https://greenroute-7251d-default-rtdb.firebaseio.com"; // Base URL for API requests

  // Method to handle GET requests
  Future<dynamic> get(String endpoint) async {
    // Construct the full URL
    final url = '$baseUrl/$endpoint';
    print('GET request to $url'); // Debug print for the request URL

    // Make the GET request
    final response = await http.get(Uri.parse(url));
    print('Response status: ${response.statusCode}'); // Debug print for response status
    print('Response body: ${response.body}'); // Debug print for response body

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body); // Decode JSON response

      // Handle the case where response is empty
      if (decodedResponse.isEmpty) {
        print('Response is empty. Returning an empty map.'); // Debug print for empty response
        return {}; // Return an empty map instead of null
      }

      return decodedResponse; // Returns the decoded JSON data
    } else {
      print('Failed GET request with status code: ${response.statusCode}'); // Debug print for error
      throw Exception('Failed to load data');
    }
  }

  // Method to handle POST requests
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = '$baseUrl/$endpoint';
    print('POST request to $url'); // Debug print for the request URL
    print('Request data: $data'); // Debug print for the request data

    // Make the POST request
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data), // Convert the data to JSON
    );

    print('Response status: ${response.statusCode}'); // Debug print for response status
    print('Response body: ${response.body}'); // Debug print for response body

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body); // Returns the decoded JSON data
    } else {
      print('Failed POST request with status code: ${response.statusCode}'); // Debug print for error
      throw Exception('Failed to post data');
    }
  }

  // Method to handle PUT requests
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final url = '$baseUrl/$endpoint';
    print('PUT request to $url'); // Debug print for the request URL
    print('Request data: $data'); // Debug print for the request data

    // Make the PUT request
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data), // Convert the data to JSON
    );

    print('Response status: ${response.statusCode}'); // Debug print for response status
    print('Response body: ${response.body}'); // Debug print for response body

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Returns the decoded JSON data
    } else {
      print('Failed PUT request with status code: ${response.statusCode}'); // Debug print for error
      throw Exception('Failed to update data');
    }
  }

  // Method to handle PATCH requests
  Future<dynamic> patch(String endpoint, Map<String, dynamic> data) async {
    final url = '$baseUrl/$endpoint';
    print('PATCH request to $url'); // Debug print for the request URL
    print('Request data: $data'); // Debug print for the request data

    // Make the PATCH request
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data), // Convert the data to JSON
    );

    print('Response status: ${response.statusCode}'); // Debug print for response status
    print('Response body: ${response.body}'); // Debug print for response body

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Returns the decoded JSON data
    } else {
      print('Failed PATCH request with status code: ${response.statusCode}'); // Debug print for error
      throw Exception('Failed to update data with PATCH');
    }
  }

  // Method to handle DELETE requests
  Future<void> delete(String endpoint) async {
    final url = '$baseUrl/$endpoint';
    print('DELETE request to $url'); // Debug print for the request URL

    // Make the DELETE request
    final response = await http.delete(Uri.parse(url));

    print('Response status: ${response.statusCode}'); // Debug print for response status

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Successfully deleted data.'); // Debug print for successful deletion
      return; // Successfully deleted, no return value needed
    } else {
      print('Failed DELETE request with status code: ${response.statusCode}'); // Debug print for error
      throw Exception('Failed to delete data');
    }
  }
}
