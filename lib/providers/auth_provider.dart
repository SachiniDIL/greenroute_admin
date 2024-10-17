import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../screens/admin_home.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  Users? _user;
  bool _isAuthenticated = false;
  final AuthService _authService = AuthService();
  String? userRole;

  Users? get user => _user;

  bool get isAuthenticated => _isAuthenticated;

  // Login method
  Future<void> login(BuildContext context, String email, String password) async {
    try {
      Users? loggedInUser = await _authService.login(email, password);
      if (loggedInUser != null) {
        _user = loggedInUser;
        _isAuthenticated = true;

        // Check if userRole is null or empty
        if (loggedInUser.userRole.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User role not found.')),
          );
          return;
        }

        // Save user role and email to Shared Preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userRole', loggedInUser.userRole);
        await prefs.setString('userEmail', loggedInUser.email);

        notifyListeners(); // Notify listeners to update UI

        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful!!')),
        );

        // Navigate based on user role
        _navigateBasedOnRole(context, loggedInUser.userRole);
      } else {
        // Show failure snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    } catch (error) {
      // Show failure snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log in: $error')),
      );
    }
  }


  void _navigateBasedOnRole(BuildContext context, String role) {
    if (role == 'admin') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AdminHomePage()));
    } else if (role == 'user') {
      // User home route
    } else {
      // Fallback route
    }
  }

  // Sign Up method (optional if needed)
  Future<void> signUp(String email, String password) async {
    try {
      Users? newUser = await _authService.signUp(email, password);
      if (newUser != null) {
        _user = newUser;
        _isAuthenticated = true;
        notifyListeners(); // Notify listeners to update UI
      }
    } catch (error) {
      throw Exception('Failed to sign up: $error');
    }
  }

  // Logout method
  Future<void> logout() async {
    _user = null;
    _isAuthenticated = false;

    // Clear Shared Preferences on logout
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userRole');
    await prefs.remove('userEmail');

    notifyListeners(); // Notify listeners to update UI
  }
}
