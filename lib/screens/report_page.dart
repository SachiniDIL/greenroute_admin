import 'package:flutter/material.dart';
import 'admin_drawer.dart'; // Import the AdminDrawer
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  List<Map<String, dynamic>> _reports = [];
  List<Map<String, dynamic>> _filteredReports = [];
  bool _isLoading = true;
  String _searchText = '';

  final String apiUrl =
      'https://greenroute-7251d-default-rtdb.firebaseio.com/reports.json'; // Replace with your actual API endpoint

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  // Fetch reports from REST API
  Future<void> _fetchReports() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      // Log the response body for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body); // It's a Map now

        List<Map<String, dynamic>> reports = [];

        if (data != null && data is Map) {
          reports = data.entries
              .map((entry) {
            final report = entry.value;
            if (report is Map<String, dynamic>) {
              return {
                "id": entry.key, // Use the key as the report ID
                "email": report["email"] ?? '',
                "subject": report["subject"] ?? '',
                "description": report["description"] ?? '',
                "status": report["status"] ?? '',
              };
            }
            return null; // Skip invalid entries
          })
              .where((report) => report != null)
              .cast<Map<String, dynamic>>()
              .toList(); // Safely remove null entries
        }

        setState(() {
          _reports = reports;
          _filteredReports = reports;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      // Print the error for debugging
      print('Error fetching reports: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Update the status of a specific report
  Future<void> _updateStatus(String reportId, String status) async {
    final url = Uri.parse('https://greenroute-7251d-default-rtdb.firebaseio.com/reports/$reportId.json');
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'status': status, // Update the status
      }),
    );

    if (response.statusCode == 200) {
      // Update the local list without reloading everything
      setState(() {
        _reports = _reports.map((report) {
          if (report["id"] == reportId) {
            report["status"] = status;
          }
          return report;
        }).toList();
        _filteredReports = _reports; // Update filtered reports as well
      });
    } else {
      throw Exception('Failed to update report');
    }
  }

  // Search function
  void _searchReports(String searchText) {
    setState(() {
      _filteredReports = _reports.where((report) {
        final email = report["email"].toString().toLowerCase();
        final subject = report["subject"].toString().toLowerCase();
        final status = report["status"].toString().toLowerCase();
        return email.contains(searchText.toLowerCase()) ||
            subject.contains(searchText.toLowerCase()) ||
            status.contains(searchText.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      drawer: const AdminDrawer(), // Add the drawer
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner
          : Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (text) {
                _searchReports(text);
                _searchText = text;
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          // Table of reports
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Subject')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _filteredReports.map(
                      (report) {
                    return DataRow(
                      cells: [
                        DataCell(Text(report["email"])),
                        DataCell(Text(report["subject"])),
                        DataCell(Text(report["description"])),
                        DataCell(Text(report["status"])),
                        DataCell(
                          Row(
                            children: [
                              // Accept button
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: report["status"] == "processing"
                                      ? Colors.green
                                      : Colors.grey[300],
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.check),
                                  onPressed: () {
                                    _updateStatus(report["id"], 'processing');
                                  },
                                  tooltip: 'Accept',
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8), // Add space between the icons
                              // Cancel button
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: report["status"] == "canceled"
                                      ? Colors.red
                                      : Colors.grey[300],
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.cancel),
                                  onPressed: () {
                                    _updateStatus(report["id"], 'canceled');
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
