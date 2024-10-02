import 'package:flutter/material.dart';
import 'admin_drawer.dart'; // Import the AdminDrawer

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      drawer: const AdminDrawer(), // Add the drawer
      body: const Center(
        child: Text('Reports Page'),
      ),
    );
  }
}
