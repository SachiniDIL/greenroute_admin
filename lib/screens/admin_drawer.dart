import 'package:flutter/material.dart';
import 'package:greenroute_admin/screens/admin_home.dart';
import 'residents_page.dart';
import 'truck_drivers_page.dart';
import 'trucks_page.dart';
import 'schedule_page.dart';
import 'special_requests_page.dart';
import 'login.dart';
// Import your new pages here
import 'feedback_page.dart';
import 'report_page.dart';
import 'public_collecting.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(
                  Icons.admin_panel_settings,
                  size: 50,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AdminHomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Residents'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ResidentsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_shipping),
            title: const Text('Truck Drivers'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const TruckDriversPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.fire_truck),
            title: const Text('Trucks'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TrucksPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Schedule'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SchedulePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.request_page),
            title: const Text('Special Requests'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const SpecialRequestsPage()),
              );
            },
          ),
          // New items for Feedback, Reports, and Public Collecting Places
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Feedback'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const FeedbackPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Reports'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ReportsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.place),
            title: const Text('Public Collecting Places'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const PublicCollectingPlacesPage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Log out and navigate back to login screen
              Navigator.pop(context); // Close drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminLoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
