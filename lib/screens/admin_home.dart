import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      drawer: const Sidebar(), // Reuse the same drawer
      body: const Center(
        child: Text(
          'Welcome to the Admin Dashboard',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
