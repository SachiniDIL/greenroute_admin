import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin_drawer.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Map<String, dynamic>> _schedules = [];
  List<Map<String, dynamic>> _filteredSchedules = [];
  bool _isLoading = true;
  String _searchText = '';

  final String apiUrl =
      'https://greenroute-7251d-default-rtdb.firebaseio.com/schedule.json'; // Firebase Realtime Database endpoint

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
  }

  // Fetch schedules from REST API
  // Fetch schedules from REST API
  Future<void> _fetchSchedules() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        List<Map<String, dynamic>> schedules = [];

        if (data != null) {
          if (data is Map<String, dynamic>) {
            // If the data is a map, handle it as a map
            schedules = data.entries.map((entry) {
              final schedule = entry.value as Map<String, dynamic>;
              return {
                "id": entry.key,  // Use the key as the ID
                "date": schedule["date"] ?? '',
                "time": schedule["time"] ?? '',
                "truck": schedule["truck"] ?? '',
                "truck_driver_email": schedule["truck_driver_mail"] ?? '',
              };
            }).toList();
          } else if (data is List) {
            // If the data is a list, handle it as a list
            schedules = data.map((schedule) {
              return {
                "id": "",  // No unique ID in this case
                "date": schedule["date"] ?? '',
                "time": schedule["time"] ?? '',
                "truck": schedule["truck"] ?? '',
                "truck_driver_email": schedule["truck_driver_mail"] ?? '',
              };
            }).toList().cast<Map<String, dynamic>>();  // Ensure the list is cast to the correct type
          }
        }

        setState(() {
          _schedules = schedules;
          _filteredSchedules = schedules; // Initially show all schedules
          _isLoading = false; // Data has been fetched, stop loading
        });

      } else {
        throw Exception('Failed to load schedules');
      }
    } catch (e) {
      // Handle any errors here
      print('Error fetching schedules: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }


  // Search function
  void _searchSchedules(String searchText) {
    setState(() {
      _filteredSchedules = _schedules.where((schedule) {
        final date = schedule["date"]?.toString().toLowerCase() ?? '';
        final time = schedule["time"]?.toString().toLowerCase() ?? '';
        final truck = schedule["truck"]?.toString().toLowerCase() ?? '';
        final driverEmail = schedule["truck_driver_email"]?.toString().toLowerCase() ?? '';

        return date.contains(searchText.toLowerCase()) ||
            time.contains(searchText.toLowerCase()) ||
            truck.contains(searchText.toLowerCase()) ||
            driverEmail.contains(searchText.toLowerCase());
      }).toList();
    });
  }

  // Add a new schedule
  Future<void> _addNewSchedule(String date, String time, String truck, String truckDriverEmail) async {
    final url = Uri.parse('https://greenroute-7251d-default-rtdb.firebaseio.com/schedule.json');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'date': date,
        'time': time,
        'truck': truck,
        'truck_driver_mail': truckDriverEmail,
      }),
    );

    if (response.statusCode == 200) {
      _fetchSchedules();
    } else {
      throw Exception('Failed to add schedule');
    }
  }

  // Delete a schedule
  Future<void> _deleteSchedule(String scheduleId) async {
    final url = Uri.parse('https://greenroute-7251d-default-rtdb.firebaseio.com/schedule/$scheduleId.json');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      _fetchSchedules();
    } else {
      throw Exception('Failed to delete schedule');
    }
  }

  // Update schedule details via REST API
  Future<void> _updateSchedule(String scheduleId, String date, String time, String truck, String truckDriverEmail) async {
    final url = Uri.parse('https://greenroute-7251d-default-rtdb.firebaseio.com/schedule/$scheduleId.json');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'date': date,
        'time': time,
        'truck': truck,
        'truck_driver_mail': truckDriverEmail,
      }),
    );

    if (response.statusCode == 200) {
      _fetchSchedules();
    } else {
      throw Exception('Failed to update schedule');
    }
  }

  // Show the update schedule form
  Future<void> _showUpdateForm(Map<String, dynamic> schedule) async {
    final dateController = TextEditingController(text: schedule["date"]);
    final timeController = TextEditingController(text: schedule["time"]);
    final truckController = TextEditingController(text: schedule["truck"]);
    final truckDriverEmailController = TextEditingController(text: schedule["truck_driver_email"]);

    final bool? confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Schedule'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Date'),
              ),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Time'),
              ),
              TextField(
                controller: truckController,
                decoration: const InputDecoration(labelText: 'Truck'),
              ),
              TextField(
                controller: truckDriverEmailController,
                decoration: const InputDecoration(labelText: 'Truck Driver Email'),
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
      await _updateSchedule(
        schedule["id"],
        dateController.text,
        timeController.text,
        truckController.text,
        truckDriverEmailController.text,
      );
    }
  }

  // Show the add new schedule form
  Future<void> _showAddForm() async {
    final dateController = TextEditingController();
    final timeController = TextEditingController();
    final truckController = TextEditingController();
    final truckDriverEmailController = TextEditingController();

    final bool? confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Schedule'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Date'),
              ),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Time'),
              ),
              TextField(
                controller: truckController,
                decoration: const InputDecoration(labelText: 'Truck'),
              ),
              TextField(
                controller: truckDriverEmailController,
                decoration: const InputDecoration(labelText: 'Truck Driver Email'),
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
      await _addNewSchedule(
        dateController.text,
        timeController.text,
        truckController.text,
        truckDriverEmailController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
      ),
      drawer: const AdminDrawer(), // Reuse the same drawer
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner
          : Column(
        children: [
          // Add new schedule button at the top
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _showAddForm,
              child: const Text('Add New Schedule'),
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (text) {
                _searchSchedules(text);
                _searchText = text;
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          // Table of schedules
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Time')),
                  DataColumn(label: Text('Truck')),
                  DataColumn(label: Text('Truck Driver Email')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _filteredSchedules.map(
                      (schedule) {
                    return DataRow(
                      cells: [
                        DataCell(Text(schedule["date"])),
                        DataCell(Text(schedule["time"])),
                        DataCell(Text(schedule["truck"])),
                        DataCell(Text(schedule["truck_driver_email"])),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showUpdateForm(schedule);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deleteSchedule(schedule["id"]);
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
