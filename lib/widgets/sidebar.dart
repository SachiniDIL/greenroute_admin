import 'package:flutter/material.dart';
import 'package:greenroute_admin/screens/public_locations.dart';
import 'package:greenroute_admin/screens/user_screen.dart';
import 'package:greenroute_admin/screens/waste_manager_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trash_bin.dart';
import '../screens/route_screen.dart';
import '../utils/route_generator.dart';
import '../providers/trash_bin_provider.dart'; // Import the provider

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String? _userRole;
  bool _isManager = false;
  late TrashBinProvider binProvider; // Declare the binProvider

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    binProvider = TrashBinProvider(); // Initialize the provider
  }

  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('userRole');
      _isManager = _userRole == 'manager';
    });
  }

  Future<List<List<TrashBin>>> _generateRoutes() async {
    RouteGenerator routeGenerator = RouteGenerator(binProvider);
    return await routeGenerator.generateRoutes(); // Generate routes
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue.shade700, // Background color for header
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/sidebar_bg.jpg'), // Background image (optional)
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/user_avatar.png'), // User avatar
                ),
                SizedBox(height: 10),
                Text(
                  'Hello, User', // Placeholder user greeting
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _userRole ?? 'Role', // Display user role
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSidebarItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  onTap: () {
                    // Navigate to Dashboard
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.people,
                  title: 'Users',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserScreen()),
                    );
                  },
                ),
                if (!_isManager)
                  _buildSidebarItem(
                    icon: Icons.supervised_user_circle,
                    title: 'Waste Managers',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WasteManagerScreen()),
                      );
                    },
                  ),
                _buildSidebarItem(
                  icon: Icons.local_shipping,
                  title: 'Trucks',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.person,
                  title: 'Truck Drivers',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.bar_chart,
                  title: 'Reports',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.request_page,
                  title: 'Special Requests',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.schedule,
                  title: 'Schedules',
                  onTap: () {
                    _generateRoutes().then((generatedRoutes) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoutesScreen(routes: generatedRoutes),
                        ),
                      );
                    });
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.delete,
                  title: 'Public Bins',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddPublicLocationScreen()),
                    );
                  },
                ),
                Divider(), // Adds a visual divider
                _buildSidebarItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    // Handle Logout
                    Navigator.pop(context); // Close the drawer
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade700),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.blue.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      horizontalTitleGap: 16.0,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
      dense: true, // Reduces padding between items
    );
  }
}
