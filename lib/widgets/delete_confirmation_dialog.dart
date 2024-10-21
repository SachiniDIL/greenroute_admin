import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Waste Manager'),
      content: Text('Are you sure you want to delete this waste manager?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm(); // Execute the confirm action
            Navigator.pop(context); // Close the dialog after confirmation
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }
}
