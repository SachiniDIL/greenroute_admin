// lib/services/auth_service.dart
import 'dart:convert';
import 'package:greenroute_admin/api/api_client.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService {
  final String baseUrl = 'https://greenroute-7251d-default-rtdb.firebaseio.com';
  final apiClient = ApiClient();


  get userId => null;

  get username => null;

  get address => null;

  get contactNumber => null; // Replace with your API URL

  // Sign up
  Future<Users?> signUp(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return Users.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to sign up');
    }
  }

// Login
  Future<Users?> login(String email, String password) async {
    final response = await apiClient.get("users.json"); // Fetch users data

    if (response is Map<String, dynamic>) {
      // If the response is a map, it means you fetched the user data correctly
      List<Users> users = [];
      response.forEach((key, value) {
        users.add(Users.fromJson(value)); // Assuming each user object is in the format of Users model
      });

      // Check if there's a matching user
      for (var user in users) {
        if (user.email == email && user.password == password) {
          return user; // Return the user if found
        }
      }
    }
    throw Exception('Failed to login: Invalid email or password');
  }
  // Logout (depends on backend implementation)
  Future<void> logout() async {
    // If your backend requires token revocation, send a request to logout endpoint
  }
}
