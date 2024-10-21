import 'package:flutter/material.dart';
import '../models/waste_manager.dart';
import '../services/waste_manager_service.dart';

class AddWasteManagerForm extends StatefulWidget {
  final WasteManager manager;

  const AddWasteManagerForm({super.key, required this.manager});

  @override
  _AddWasteManagerFormState createState() => _AddWasteManagerFormState();
}

class _AddWasteManagerFormState extends State<AddWasteManagerForm> {
  final _formKey = GlobalKey<FormState>();
  final WasteManagerService _wasteManagerService = WasteManagerService();

  // Controllers for form fields
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _managerIdController;
  late TextEditingController _contactNumberController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with default or passed values
    _usernameController = TextEditingController(text: widget.manager.username);
    _emailController = TextEditingController(text: widget.manager.email);
    _passwordController = TextEditingController(text: widget.manager.password);
    _managerIdController = TextEditingController(text: widget.manager.managerId);
    _contactNumberController =
        TextEditingController(text: widget.manager.contactNumber ?? '');
    _addressController = TextEditingController(text: widget.manager.address ?? '');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _managerIdController.dispose();
    _contactNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Method to handle adding the new waste manager
// Method to handle adding the new waste manager
  Future<void> _addWasteManager() async {
    if (_formKey.currentState!.validate()) {
      WasteManager newWasteManager = WasteManager(
        userId: widget.manager.userId,
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        managerId: _managerIdController.text,
        contactNumber: _contactNumberController.text,
        address: _addressController.text,
        userRole: 'waste_manager',
      );

      try {
        await _wasteManagerService.addWasteManager(newWasteManager);
        Navigator.pop(context, true); // Return true when successfully added
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Waste Manager added successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add Waste Manager: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add New Waste Manager',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                // Username Field
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                // Manager ID Field
                TextFormField(
                  controller: _managerIdController,
                  decoration: InputDecoration(labelText: 'Manager ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Manager ID';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                // Contact Number Field
                TextFormField(
                  controller: _contactNumberController,
                  decoration: InputDecoration(labelText: 'Contact Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a contact number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                // Address Field
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Save Button
                ElevatedButton(
                  onPressed: _addWasteManager,
                  child: Text('Add Waste Manager'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
