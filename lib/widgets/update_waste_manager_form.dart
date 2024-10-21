import 'package:flutter/material.dart';

import '../commands/update_waste_manager_command.dart';
import '../invoker/command_invoker.dart';
import '../models/waste_manager.dart';
import '../services/waste_manager_service.dart';

class UpdateWasteManagerForm extends StatefulWidget {
  final WasteManager manager;

  const UpdateWasteManagerForm({super.key, required this.manager});

  @override
  _UpdateWasteManagerFormState createState() => _UpdateWasteManagerFormState();
}

class _UpdateWasteManagerFormState extends State<UpdateWasteManagerForm> {
  final _formKey = GlobalKey<FormState>();
  final WasteManagerService _wasteManagerService = WasteManagerService();

  late String _username;
  late String _email;

  @override
  void initState() {
    super.initState();
    _username = widget.manager.username!;
    _email = widget.manager.email;
  }

  // Method to handle form submission
  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      WasteManager updatedManager = WasteManager(
        userId: widget.manager.userId,
        username: _username,
        email: _email,
        password: widget.manager.password,
        managerId: widget.manager.managerId,
        userRole: widget.manager.userRole,
      );

      CommandInvoker invoker = CommandInvoker();
      invoker.setCommand(
          UpdateWasteManagerCommand(_wasteManagerService, updatedManager));
      await invoker.executeCommand();

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update Waste Manager'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _username,
              decoration: InputDecoration(labelText: 'Username'),
              onSaved: (value) => _username = value!,
            ),
            TextFormField(
              initialValue: _email,
              decoration: InputDecoration(labelText: 'Email'),
              onSaved: (value) => _email = value!,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text('Update'),
        ),
      ],
    );
  }
}
