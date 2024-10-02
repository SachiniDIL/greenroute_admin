import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin_drawer.dart';

class ResidentsPage extends StatefulWidget {
  const ResidentsPage({super.key});

  @override
  _ResidentsPageState createState() => _ResidentsPageState();
}

class _ResidentsPageState extends State<ResidentsPage> {
  List<Map<String, dynamic>> _residents = [];
  List<Map<String, dynamic>> _filteredResidents = [];
  String _searchText = '';
  bool _isLoading = true;

  final String apiUrl =
      'https://greenroute-7251d-default-rtdb.firebaseio.com/users.json'; // Firebase Realtime Database endpoint

  @override
  void initState() {
    super.initState();
    _fetchResidents();
  }

  // Fetch users from REST API and filter those whose role is 'resident'
  Future<void> _fetchResidents() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Debug: Print the raw data fetched from Firebase
        print("Fetched data: $data");

        List<Map<String, dynamic>> residents = [];

        if (data is Map<String, dynamic>) {
          // If the data is a map, handle it as before
          residents = data.entries.where((entry) {
            final resident = entry.value as Map<String, dynamic>;
            return resident["role"] == "resident";
          }).map((entry) {
            final resident = entry.value;
            return {
              "id": entry.key,  // Use the key as the ID
              "fullname": resident["fullname"],
              "email": resident["email"],
              "nic": resident["nic"],
              "mobile": resident["mobile"]
            };
          }).toList();
        } else if (data is List) {
          // If the data is a list, iterate through it and filter the residents
          residents = data.where((item) {
            final resident = item as Map<String, dynamic>;
            return resident["role"] == "resident";
          }).map((resident) {
            return {
              "id": "",  // No unique ID in this case, so leave empty or use index
              "fullname": resident["fullname"],
              "email": resident["email"],
              "nic": resident["nic"],
              "mobile": resident["mobile"]
            };
          }).toList();
        }

        setState(() {
          _residents = residents;
          _filteredResidents = _residents; // Initially show all residents
          _isLoading = false; // Data has been fetched, stop loading
        });

        // Debugging: Print the residents filtered and ready for display
        print('Filtered Residents: $_residents');
      } else {
        throw Exception('Failed to load residents');
      }
    } catch (e) {
      // Handle any errors here
      print('Error fetching residents: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }


  // Search function
  void _searchResidents(String searchText) {
    setState(() {
      _filteredResidents = _residents.where((resident) {
        return resident!["fullname"]
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            resident["email"]
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase());
      }).toList();
    });
  }

  // Delete resident from REST API
  Future<void> _deleteResident(String residentId) async {
    final url = Uri.parse(
        'https://greenroute-7251d-default-rtdb.firebaseio.com/users/$residentId.json');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // Re-fetch the residents list after deletion
      _fetchResidents();
    } else {
      throw Exception('Failed to delete resident');
    }
  }

  // Update resident details via REST API
  Future<void> _updateResident(String residentId, String fullname, String email,
      String nic, String mobile) async {
    final url = Uri.parse(
        'https://greenroute-7251d-default-rtdb.firebaseio.com/users/$residentId.json');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'fullname': fullname,
        'email': email,
        'nic': nic,
        'mobile': mobile,
      }),
    );

    if (response.statusCode == 200) {
      _fetchResidents();
    } else {
      throw Exception('Failed to update resident');
    }
  }

  // Show the update resident form
  Future<void> _showUpdateForm(Map<String, dynamic> resident) async {
    final fullnameController =
        TextEditingController(text: resident["fullname"]);
    final emailController = TextEditingController(text: resident["email"]);
    final nicController = TextEditingController(text: resident["nic"]);
    final mobileController = TextEditingController(text: resident["mobile"]);

    final bool? confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Resident'),
          content: Column(
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
                controller: nicController,
                decoration: const InputDecoration(labelText: 'NIC'),
              ),
              TextField(
                controller: mobileController,
                decoration: const InputDecoration(labelText: 'Mobile'),
              ),
            ],
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

    if (confirmed == true) {
      await _updateResident(resident["id"], fullnameController.text,
          emailController.text, nicController.text, mobileController.text);
    }
  }

  // Delete confirmation dialog
  Future<void> _confirmDelete(String residentId) async {
    final bool? confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this resident?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _deleteResident(residentId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Residents'),
      ),
      drawer: const AdminDrawer(), // Reuse the same drawer
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading spinner
          : Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (text) {
                      _searchResidents(text);
                      _searchText = text;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                // Table of residents
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Full Name')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('NIC')),
                        DataColumn(label: Text('Mobile')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: _filteredResidents.map(
                        (resident) {
                          return DataRow(
                            cells: [
                              DataCell(Text(resident!["fullname"])),
                              DataCell(Text(resident["email"])),
                              DataCell(Text(resident["nic"])),
                              DataCell(Text(resident["mobile"])),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        _showUpdateForm(resident);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _confirmDelete(resident["id"]);
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
