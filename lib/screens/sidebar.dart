import 'package:flutter/material.dart';
import 'package:greenroute_admin/screens/public_locations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String? _userRole;
  bool _isManager = false;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('userRole');
      _isManager = _userRole == 'manager';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Dashboard'),
            onTap: () {
              // Navigate to Dashboard
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: const Text('Residents'),
            onTap: () {
              // Navigate to Residents
              Navigator.pop(context); // Close the drawer
            },
          ),
          if (!_isManager) // Show this item only if the user is not a manager
            ListTile(
              title: const Text('Waste Managers'),
              onTap: () {
                // Navigate to Waste Managers
                Navigator.pop(context); // Close the drawer
              },
            ),
          ListTile(
            title: const Text('Trucks'),
            onTap: () {
              // Navigate to Trucks
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: const Text('Truck Drivers'),
            onTap: () {
              // Navigate to Truck Drivers
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: const Text('Reports'),
            onTap: () {
              // Navigate to Reports
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: const Text('Special Requests'),
            onTap: () {
              // Navigate to Special Requests
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: const Text('Schedules'),
            onTap: () {
              // Navigate to Schedules
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: const Text('Public Bins'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddPublicLocationScreen()));
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              // Handle Logout
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}
