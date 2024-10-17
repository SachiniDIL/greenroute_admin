import 'package:flutter/material.dart';
import 'package:greenroute_admin/providers/auth_provider.dart';
import 'package:greenroute_admin/utils/snack_bar_util.dart';
import '../utils/validators.dart';
import 'business_signup.dart'; // Import your AdminHomePage

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoginPressed = false;
  String? _usernameError;
  String? _passwordError;

  Future<void> _login() async {
    setState(() {
      _isLoginPressed = true;
      _usernameError = null;
      _passwordError = null; // Reset errors before validation
    });

    String enteredUsername = _usernameController.text;
    String enteredPassword = _passwordController.text;

    // Validate inputs
    _usernameError = Validators.validateEmail(enteredUsername);
    _passwordError = Validators.validatePassword(enteredPassword);

    if (_usernameError != null || _passwordError != null) {
      // Show error messages if validation fails
      setState(() {
        _isLoginPressed = false; // Reset login button state
      });
      return; // Exit the method if validation fails
    }

    AuthProvider authProvider = AuthProvider();

    // Attempt login
    try {
      await authProvider.login(context, enteredUsername, enteredPassword);
    } catch (e) {
      SnackbarUtils.showSnackbar(
        context,
        'Login failed: $e',
        color: Colors.red,
      );
    } finally {
      setState(() {
        _isLoginPressed = false; // Reset the login button state
      });
    }
  }

  // Navigate to SignUpScreen
  void _navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BusinessSignUpScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 8.0,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: const OutlineInputBorder(),
                      errorText: _usernameError, // Show email validation error
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      errorText: _passwordError,
                      // Show password validation error
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoginPressed ? null : () => _login(),
                    // Disable button if logging in
                    child: _isLoginPressed
                        ? const CircularProgressIndicator()
                        : const Text('Login'),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: _navigateToSignUp, // Navigate to Sign-Up
                    child: const Text('Don\'t have an account? Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
