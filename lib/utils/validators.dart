class Validators {
  // Validate Email
  static String? validateEmail(String? value, {String errorMessage = 'Enter a valid email'}) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return errorMessage;
    }
    return null;
  }

  // Validate Mobile Number
  static String? validateMobile(String? value, {String errorMessage = 'Enter a valid 10-digit mobile number'}) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }
    if (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return errorMessage;
    }
    return null;
  }

  // Validate Postal Code
  static String? validatePostalCode(String? value, {String errorMessage = 'Enter a valid 5-digit postal code'}) {
    if (value == null || value.isEmpty) {
      return 'Postal code is required';
    }
    if (value.length != 5 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return errorMessage;
    }
    return null;
  }

  // Validate Password
  static String? validatePassword(String? value, {String errorMessage = 'Password must be at least 6 characters long'}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return errorMessage;
    }
    return null;
  }

  // Validate Password Strength (optional)
  static String? validateStrongPassword(String? value, {String errorMessage = 'Password must be strong'}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$'); // Minimum 8 characters, 1 letter, 1 number
    if (!passwordRegex.hasMatch(value)) {
      return errorMessage;
    }

    return null;
  }

  // Validate Confirm Password
  static String? validateConfirmPassword(String? value, String? password, {String errorMessage = 'Passwords do not match'}) {
    if (value == null || value.isEmpty) {
      return 'Confirm your password';
    }
    if (value != password) {
      return errorMessage;
    }
    return null;
  }
}
