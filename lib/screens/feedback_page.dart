import 'package:flutter/material.dart';
import 'admin_drawer.dart'; // Import the AdminDrawer

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      drawer: const AdminDrawer(), // Add the drawer
      body: const Center(
        child: Text('Feedback Page'),
      ),
    );
  }
}
