import 'package:flutter/material.dart';
import '../widgets/sidebar.dart'; // Import the AdminDrawer

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      drawer: const Sidebar(), // Add the drawer
      body: const Center(
        child: Text('Feedback Page'),
      ),
    );
  }
}
