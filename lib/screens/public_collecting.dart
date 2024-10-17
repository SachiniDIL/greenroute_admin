import 'package:flutter/material.dart';
// Import the AdminDrawer

class PublicCollectingPlacesPage extends StatelessWidget {
  const PublicCollectingPlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Public Collecting Places'),
      ),
      drawer: const AdminDrawer(), // Add the drawer
      body: const Center(
        child: Text('Public Collecting Places Page'),
      ),
    );
  }
}
