import 'package:flutter/material.dart';
import 'package:greenroute_admin/providers/business_provider.dart';
import 'package:greenroute_admin/utils/snack_bar_util.dart';
import '../utils/validators.dart';
import 'location_picker_screen.dart'; // Import the Location Picker screen

class BusinessSignUpScreen extends StatefulWidget {
  const BusinessSignUpScreen({super.key});

  @override
  _BusinessSignupScreenState createState() => _BusinessSignupScreenState();
}

class _BusinessSignupScreenState extends State<BusinessSignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController =
  TextEditingController(); // Address field controller
  String? _businessType;
  bool _isSignUpPressed = false;
  final BusinessProvider _businessProvider = BusinessProvider();

  // Location fields
  String? _locationName;
  double? _latitude;
  double? _longitude;

  // Password visibility flags
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Method to navigate to location picker
  Future<void> _pickLocation() async {
    final locationData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerScreen(), // Location picker screen
      ),
    );

    if (locationData != null) {
      setState(() {
        _latitude = locationData['latitude'];
        _longitude = locationData['longitude'];
        _locationName = locationData['name'];
      });
    }
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSignUpPressed = true;
    });

    String businessName = _businessNameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String phoneNumber = _phoneNumberController.text;
    String address = _addressController.text;

    try {
      await _businessProvider.registerBusiness(
        businessName: businessName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        businessType: _businessType!,
        address: address,
        latitude: _latitude!,
        longitude: _longitude!,
        locationName: _locationName!,
        trashLevel: 0.0,
        sensorData: '', // Default sensor data
      );

      SnackbarUtils.showSnackbar(
        context,
        'Business registered successfully!',
        color: Colors.green,
      );
    } catch (e) {
      SnackbarUtils.showSnackbar(
        context,
        'Sign-up failed: $e',
        color: Colors.red,
      );
    } finally {
      setState(() {
        _isSignUpPressed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Sign Up'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;

          // Adjust padding and width for larger screens
          double horizontalPadding = width < 600 ? 16.0 : width * 0.15;
          double formWidth = width < 600 ? width * 0.9 : 600;

          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: SizedBox(
                  width: formWidth,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 8.0,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _businessNameController,
                              decoration: const InputDecoration(
                                labelText: 'Business Name',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Business name is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  Validators.validateEmail(value),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible =
                                      !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) =>
                                  Validators.validatePassword(value),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: !_isConfirmPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isConfirmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) =>
                                  Validators.validateConfirmPassword(
                                      value, _passwordController.text),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _phoneNumberController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  Validators.validateMobile(value),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                labelText: 'Address',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Address is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              value: _businessType,
                              hint: const Text('Select Business Type'),
                              items: [
                                'Retail',
                                'Service',
                                'Manufacturing',
                                'Other'
                              ].map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _businessType = value;
                                });
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a business type';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // Location picker field
                            GestureDetector(
                              onTap: _pickLocation,
                              child: AbsorbPointer(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: _locationName == null
                                        ? 'Select Location'
                                        : 'Location: $_locationName',
                                    border: const OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (_locationName == null) {
                                      return 'Please select a location';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            ElevatedButton(
                              onPressed: _isSignUpPressed ? null : _signUp,
                              child: _isSignUpPressed
                                  ? const CircularProgressIndicator()
                                  : const Text('Sign Up'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
