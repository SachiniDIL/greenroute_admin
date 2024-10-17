import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TrucksPage extends StatefulWidget {
  const TrucksPage({super.key});

  @override
  _TrucksPageState createState() => _TrucksPageState();
}

class _TrucksPageState extends State<TrucksPage> {
  List<Map<String, dynamic>> _trucks = [];
  List<Map<String, dynamic>> _filteredTrucks = [];
  bool _isLoading = true;
  String _searchText = '';

  final String apiUrl =
      'https://greenroute-7251d-default-rtdb.firebaseio.com/garbage_trucks.json'; // Firebase Realtime Database endpoint

  @override
  void initState() {
    super.initState();
    _fetchTrucks();
  }

  // Fetch trucks from REST API
  // Fetch trucks from REST API
  Future<void> _fetchTrucks() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        List<Map<String, dynamic>> trucks = [];

        if (data != null) {
          if (data is Map<String, dynamic>) {
            // If the data is a map, handle it as a map
            trucks = data.entries.map((entry) {
              final truck = entry.value as Map<String, dynamic>;
              return {
                "id": entry.key,  // Use the key as the ID
                "truck_number": truck["truck_number"] ?? '',
                "capacity": truck["capacity"] ?? 0,
                "status": truck["status"] == true ? 'Active' : 'Inactive',
                "current_fuel": truck["current_fuel"] ?? 0,
                "last_service_date": truck["last_service_date"] ?? '',
              };
            }).toList();
          } else if (data is List) {
            // If the data is a list, handle it as a list
            trucks = data.map((truck) {
              if (truck == null) return null;
              return {
                "id": "",  // No unique ID in this case
                "truck_number": truck["truck_number"] ?? '',
                "capacity": truck["capacity"] ?? 0,
                "status": truck["status"] == true ? 'Active' : 'Inactive',
                "current_fuel": truck["current_fuel"] ?? 0,
                "last_service_date": truck["last_service_date"] ?? '',
              };
            }).toList().cast<Map<String, dynamic>>();  // Ensure the list is cast to the correct type
          }
        }

        setState(() {
          _trucks = trucks;
          _filteredTrucks = trucks; // Initially show all trucks
          _isLoading = false; // Data has been fetched, stop loading
        });

      } else {
        throw Exception('Failed to load trucks');
      }
    } catch (e) {
      // Handle any errors here
      print('Error fetching trucks: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }


  // Search function
  void _searchTrucks(String searchText) {
    setState(() {
      _filteredTrucks = _trucks.where((truck) {
        final truckNumber = truck["truck_number"]?.toString().toLowerCase() ?? '';
        final capacity = truck["capacity"]?.toString().toLowerCase() ?? '';
        final status = truck["status"]?.toString().toLowerCase() ?? '';
        final fuel = truck["current_fuel"]?.toString().toLowerCase() ?? '';

        return truckNumber.contains(searchText.toLowerCase()) ||
            capacity.contains(searchText.toLowerCase()) ||
            status.contains(searchText.toLowerCase()) ||
            fuel.contains(searchText.toLowerCase());
      }).toList();
    });
  }

  // Add a new truck
  Future<void> _addNewTruck(String truckNumber, int capacity, bool status, int currentFuel, String lastServiceDate) async {
    final url = Uri.parse('https://greenroute-7251d-default-rtdb.firebaseio.com/garbage_trucks.json');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'truck_number': truckNumber,
        'capacity': capacity,
        'status': status,
        'current_fuel': currentFuel,
        'last_service_date': lastServiceDate,
      }),
    );

    if (response.statusCode == 200) {
      _fetchTrucks();
    } else {
      throw Exception('Failed to add truck');
    }
  }

  // Delete a truck
  Future<void> _deleteTruck(String truckId) async {
    final url = Uri.parse('https://greenroute-7251d-default-rtdb.firebaseio.com/garbage_trucks/$truckId.json');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      _fetchTrucks();
    } else {
      throw Exception('Failed to delete truck');
    }
  }

  // Update truck details via REST API
  Future<void> _updateTruck(String truckId, String truckNumber, int capacity, bool status, int currentFuel, String lastServiceDate) async {
    final url = Uri.parse('https://greenroute-7251d-default-rtdb.firebaseio.com/garbage_trucks/$truckId.json');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'truck_number': truckNumber,
        'capacity': capacity,
        'status': status,
        'current_fuel': currentFuel,
        'last_service_date': lastServiceDate,
      }),
    );

    if (response.statusCode == 200) {
      _fetchTrucks();
    } else {
      throw Exception('Failed to update truck');
    }
  }

  // Show the update truck form
  Future<void> _showUpdateForm(Map<String, dynamic> truck) async {
    final truckNumberController = TextEditingController(text: truck["truck_number"]);
    final capacityController = TextEditingController(text: truck["capacity"].toString());
    final fuelController = TextEditingController(text: truck["current_fuel"].toString());
    final lastServiceDateController = TextEditingController(text: truck["last_service_date"]);
    bool status = truck["status"] == 'Active';

    final bool? confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Truck'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: truckNumberController,
                decoration: const InputDecoration(labelText: 'Truck Number'),
              ),
              TextField(
                controller: capacityController,
                decoration: const InputDecoration(labelText: 'Capacity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: fuelController,
                decoration: const InputDecoration(labelText: 'Current Fuel'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: lastServiceDateController,
                decoration: const InputDecoration(labelText: 'Last Service Date (YYYY-MM-DD)'),
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
      await _updateTruck(
        truck["id"],
        truckNumberController.text,
        int.parse(capacityController.text),
        status,
        int.parse(fuelController.text),
        lastServiceDateController.text,
      );
    }
  }

  // Show the add new truck form
  Future<void> _showAddForm() async {
    final truckNumberController = TextEditingController();
    final capacityController = TextEditingController();
    final fuelController = TextEditingController();
    final lastServiceDateController = TextEditingController();
    bool status = true; // Default to active

    final bool? confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Truck'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: truckNumberController,
                decoration: const InputDecoration(labelText: 'Truck Number'),
              ),
              TextField(
                controller: capacityController,
                decoration: const InputDecoration(labelText: 'Capacity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: fuelController,
                decoration: const InputDecoration(labelText: 'Current Fuel'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: lastServiceDateController,
                decoration: const InputDecoration(labelText: 'Last Service Date (YYYY-MM-DD)'),
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

    if (confirmed == true) {
      await _addNewTruck(
        truckNumberController.text,
        int.parse(capacityController.text),
        status,
        int.parse(fuelController.text),
        lastServiceDateController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trucks'),
      ),
      drawer: const AdminDrawer(), // Reuse the same drawer
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner
          : Column(
        children: [
          // Add new truck button at the top
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _showAddForm,
              child: const Text('Add New Truck'),
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (text) {
                _searchTrucks(text);
                _searchText = text;
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          // Table of trucks
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Truck Number')),
                  DataColumn(label: Text('Capacity')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Current Fuel')),
                  DataColumn(label: Text('Last Service Date')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _filteredTrucks.map(
                      (truck) {
                    return DataRow(
                      cells: [
                        DataCell(Text(truck["truck_number"] ?? '')),
                        DataCell(Text(truck["capacity"].toString())),
                        DataCell(Text(truck["status"] ?? '')),
                        DataCell(Text(truck["current_fuel"].toString())),
                        DataCell(Text(truck["last_service_date"] ?? '')),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showUpdateForm(truck);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deleteTruck(truck["id"]);
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
