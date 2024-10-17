import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SpecialRequestsPage extends StatefulWidget {
  const SpecialRequestsPage({super.key});

  @override
  _SpecialRequestsPageState createState() => _SpecialRequestsPageState();
}

class _SpecialRequestsPageState extends State<SpecialRequestsPage> {
  List<Map<String, dynamic>> _requests = [];
  List<Map<String, dynamic>> _filteredRequests = [];
  bool _isLoading = true;
  String _searchText = '';

  final String apiUrl =
      'https://greenroute-7251d-default-rtdb.firebaseio.com/special_requests.json'; // Firebase Realtime Database endpoint

  @override
  void initState() {
    super.initState();
    _fetchSpecialRequests();
  }

  // Fetch special requests from REST API
  Future<void> _fetchSpecialRequests() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        List<Map<String, dynamic>> requests = [];

        if (data != null) {
          if (data is Map<String, dynamic>) {
            // Handle data when it's a map
            requests = data.entries.map((entry) {
              final request = entry.value;

              // Ensure that the request is a map, and handle possible strings or invalid data
              if (request is Map<String, dynamic>) {
                return {
                  "id": entry.key, // Use the key as the ID
                  "event_name": request["event_name"] ?? '',
                  "location": request["location"] ?? '',
                  "additional_note": request["additional_note"] ?? '',
                  "status": request["status"] ?? '',
                  "created_at": request["created_at"] ?? '',
                };
              } else {
                // Skip invalid data (e.g., if it's a string or unexpected type)
                return null;
              }
            }).where((element) => element != null).cast<Map<String, dynamic>>().toList();
          } else if (data is List) {
            // Handle data when it's a list
            requests = data.map((request) {
              if (request is Map<String, dynamic>) {
                return {
                  "id": "",  // No unique ID in this case
                  "event_name": request["event_name"] ?? '',
                  "location": request["location"] ?? '',
                  "additional_note": request["additional_note"] ?? '',
                  "status": request["status"] ?? '',
                  "created_at": request["created_at"] ?? '',
                };
              } else {
                return null; // Skip invalid data
              }
            }).where((element) => element != null).cast<Map<String, dynamic>>().toList();
          }
        }

        setState(() {
          _requests = requests;
          _filteredRequests = requests; // Initially show all requests
          _isLoading = false; // Data has been fetched, stop loading
        });

      } else {
        throw Exception('Failed to load special requests');
      }
    } catch (e) {
      // Handle any errors here
      print('Error fetching special requests: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Search function
  void _searchRequests(String searchText) {
    setState(() {
      _filteredRequests = _requests.where((request) {
        final eventName = request["event_name"]?.toString().toLowerCase() ?? '';
        final location = request["location"]?.toString().toLowerCase() ?? '';
        final status = request["status"]?.toString().toLowerCase() ?? '';
        final createdAt = request["created_at"]?.toString().toLowerCase() ?? '';

        return eventName.contains(searchText.toLowerCase()) ||
            location.contains(searchText.toLowerCase()) ||
            status.contains(searchText.toLowerCase()) ||
            createdAt.contains(searchText.toLowerCase());
      }).toList();
    });
  }

  // Accept a special request and update the status
  Future<void> _acceptRequest(String requestId) async {
    final url = Uri.parse('https://greenroute-7251d-default-rtdb.firebaseio.com/special_requests/$requestId.json');
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'status': 'processing', // Update the status to 'processing'
      }),
    );

    if (response.statusCode == 200) {
      _fetchSpecialRequests(); // Reload the requests after update
    } else {
      throw Exception('Failed to accept request');
    }
  }

  // Cancel a special request and update the status
  Future<void> _cancelRequest(String requestId) async {
    final url = Uri.parse('https://greenroute-7251d-default-rtdb.firebaseio.com/special_requests/$requestId.json');
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'status': 'canceled', // Update the status to 'canceled'
      }),
    );

    if (response.statusCode == 200) {
      _fetchSpecialRequests(); // Reload the requests after update
    } else {
      throw Exception('Failed to cancel request');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Special Requests'),
      ),
      drawer: const AdminDrawer(), // Reuse the same drawer
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner
          : Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (text) {
                _searchRequests(text);
                _searchText = text;
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          // Table of special requests
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Event Name')),
                  DataColumn(label: Text('Location')),
                  DataColumn(label: Text('Note')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Created At')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _filteredRequests.map(
                      (request) {
                    return DataRow(
                      cells: [
                        DataCell(Text(request["event_name"])),
                        DataCell(Text(request["location"])),
                        DataCell(Text(request["additional_note"])),
                        DataCell(Text(request["status"])),
                        DataCell(Text(request["created_at"])),
                        DataCell(
                          Row(
                            children: [
                              // Accept button with green circle background when clicked
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: request["status"] == "processing"
                                      ? Colors.green
                                      : Colors.grey[300], // Change to green if status is "processing"
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.check),
                                  onPressed: () {
                                    _acceptRequest(request["id"]);
                                  },
                                  tooltip: 'Accept',
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8), // Add space between the icons
                              // Cancel button with red circle background when clicked
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: request["status"] == "canceled"
                                      ? Colors.red
                                      : Colors.grey[300], // Change to red if status is "canceled"
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.cancel),
                                  onPressed: () {
                                    _cancelRequest(request["id"]);
                                  },
                                  tooltip: 'Cancel',
                                  color: Colors.white,
                                ),
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
