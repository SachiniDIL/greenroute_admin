import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin_drawer.dart';

class TruckDriversPage extends StatefulWidget {
  const TruckDriversPage({super.key});

  @override
  _TruckDriversPageState createState() => _TruckDriversPageState();
}

class _TruckDriversPageState extends State<TruckDriversPage> {
  List<Map<String, dynamic>> _drivers = [];
  List<Map<String, dynamic>> _filteredDrivers = [];
  String _searchText = '';
  bool _isLoading = true;

  final String apiUrl =
      'https://greenroute-7251d-default-rtdb.firebaseio.com/truck_drivers.json'; // Firebase Realtime Database endpoint

  @override
  void initState() {
    super.initState();
    _fetchTruckDrivers();
  }

  // Fetch drivers from REST API with null handling
  Future<void> _fetchTruckDrivers() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Debug: Print the raw data fetched from Firebase
        print("Fetched truck drivers data: $data");

        List<Map<String, dynamic>> drivers = [];

        if (data != null) {
          if (data is Map<String, dynamic>) {
            // If the data is a map, handle it
            drivers = data.entries.map((entry) {
              final driverValue = entry.value;
              if (driverValue == null) return null;
              final driver = driverValue as Map<String, dynamic>;

              return {
                "id": entry.key ?? '',
                "fullname": driver["fullname"] ?? '',
                "email": driver["email"] ?? '',
                "employee_id": driver["employee_id"] ?? '',
                "truck_number": driver["truck_number"] ?? '',
                "status": (driver["status"] == true) ? 'Active' : 'Inactive',
              };
            }).where((driver) => driver != null).cast<Map<String, dynamic>>().toList();
          } else if (data is List) {
            // If the data is a list, iterate through it
            drivers = data.map((driverValue) {
              if (driverValue == null) return null;
              final driver = driverValue as Map<String, dynamic>;

              return {
                "id": '', // No unique ID in this case
                "fullname": driver["fullname"] ?? '',
                "email": driver["email"] ?? '',
                "employee_id": driver["employee_id"] ?? '',
                "truck_number": driver["truck_number"] ?? '',
                "status": (driver["status"] == true) ? 'Active' : 'Inactive',
              };
            }).where((driver) => driver != null).cast<Map<String, dynamic>>().toList();
          }
        }

        setState(() {
          _drivers = drivers;
          _filteredDrivers = _drivers; // Initially show all drivers
          _isLoading = false; // Data has been fetched, stop loading
        });

        // Debugging: Print the drivers filtered and ready for display
        print('Filtered Truck Drivers: $_drivers');
      } else {
        throw Exception('Failed to load truck drivers');
      }
    } catch (e) {
      // Handle any errors here
      print('Error fetching truck drivers: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Search function with null handling
  void _searchDrivers(String searchText) {
    setState(() {
      _filteredDrivers = _drivers.where((driver) {
        final fullname = driver["fullname"]?.toLowerCase() ?? '';
        final email = driver["email"]?.toLowerCase() ?? '';
        final truckNumber = driver["truck_number"]?.toLowerCase() ?? '';
        final searchLower = searchText.toLowerCase();
        return fullname.contains(searchLower) ||
            email.contains(searchLower) ||
            truckNumber.contains(searchLower);
      }).toList();
    });
  }

  // Add a new driver
  Future<void> _addNewDriver(String fullname, String email, String truckNumber, bool status) async {
    final String employeeId = 'EMP_${DateTime.now().millisecondsSinceEpoch}'; // Generate unique employee_id
    final url = Uri.parse('https://greenroute-7251d-default-rtdb.firebaseio.com/truck_drivers.json');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'fullname': fullname,
        'email': email,
        'employee_id': employeeId,
        'truck_number': truckNumber,
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      _fetchTruckDrivers();
    } else {
      throw Exception('Failed to add truck driver');
    }
  }

  // Delete a driver with null handling
  Future<void> _deleteDriver(String? driverId) async {
    if (driverId == null || driverId.isEmpty) {
      print('Cannot delete driver with null or empty ID');
      return;
    }
    final url = Uri.parse('https://greenroute-7251d-default-rtdb.firebaseio.com/truck_drivers/$driverId.json');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      _fetchTruckDrivers();
    } else {
      throw Exception('Failed to delete truck driver');
    }
  }

  // Update driver details via REST API with null handling
  Future<void> _updateDriver(String? driverId, String fullname, String email, String truckNumber, bool status) async {
    if (driverId == null || driverId.isEmpty) {
      print('Cannot update driver with null or empty ID');
      return;
    }
    final url = Uri.parse('https://greenroute-7251d-default-rtdb.firebaseio.com/truck_drivers/$driverId.json');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'fullname': fullname,
        'email': email,
        'truck_number': truckNumber,
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      _fetchTruckDrivers();
    } else {
      throw Exception('Failed to update truck driver');
    }
  }

  // Show the update driver form with null handling
  Future<void> _showUpdateForm(Map<String, dynamic> driver) async {
    final fullnameController = TextEditingController(text: driver["fullname"] ?? '');
    final emailController = TextEditingController(text: driver["email"] ?? '');
    final truckNumberController = TextEditingController(text: driver["truck_number"] ?? '');
    bool status = driver["status"] == 'Active';

    final bool? confirmed = await showDialog(
      context: context,
      builder: (context) {
        // Use StatefulBuilder to handle state inside the dialog
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Update Truck Driver'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: fullnameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: truckNumberController,
                      decoration: const InputDecoration(labelText: 'Truck Number'),
                    ),
                    CheckboxListTile(
                      value: status,
                      onChanged: (newValue) {
                        setState(() {
                          status = newValue ?? false;
                        });
                      },
                      title: const Text("Active Status"),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed == true) {
      await _updateDriver(
        driver["id"],
        fullnameController.text,
        emailController.text,
        truckNumberController.text,
        status,
      );
    }
  }

  // Show the add new driver form with null handling
  Future<void> _showAddForm() async {
    final fullnameController = TextEditingController();
    final emailController = TextEditingController();
    final truckNumberController = TextEditingController();
    bool status = true; // Default to active

    final bool? confirmed = await showDialog(
      context: context,
      builder: (context) {
        // Use StatefulBuilder to handle state inside the dialog
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Truck Driver'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: fullnameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: truckNumberController,
                      decoration: const InputDecoration(labelText: 'Truck Number'),
                    ),
                    CheckboxListTile(
                      value: status,
                      onChanged: (newValue) {
                        setState(() {
                          status = newValue ?? false;
                        });
                      },
                      title: const Text("Active Status"),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed == true) {
      await _addNewDriver(
        fullnameController.text,
        emailController.text,
        truckNumberController.text,
        status,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Truck Drivers'),
      ),
      drawer: const AdminDrawer(), // Reuse the same drawer
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner
          : Column(
        children: [
          // Add new driver button at the top
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _showAddForm,
              child: const Text('Add New Driver'),
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (text) {
                _searchDrivers(text);
                _searchText = text;
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          // Table of truck drivers
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Full Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Employee ID')),
                  DataColumn(label: Text('Truck Number')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _filteredDrivers.where((driver) => driver != null).map(
                      (driver) {
                    return DataRow(
                      cells: [
                        DataCell(Text(driver["fullname"] ?? '')),
                        DataCell(Text(driver["email"] ?? '')),
                        DataCell(Text(driver["employee_id"] ?? '')),
                        DataCell(Text(driver["truck_number"] ?? '')),
                        DataCell(Text(driver["status"] ?? '')),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showUpdateForm(driver);
                                },
                              ),
                              if (driver["id"] != null && driver["id"].toString().isNotEmpty)
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteDriver(driver["id"]);
                                  },
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
