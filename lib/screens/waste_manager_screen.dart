import 'package:flutter/material.dart';
import 'package:greenroute_admin/services/user_service.dart';

import '../commands/delete_waste_manager_command.dart';
import '../invoker/command_invoker.dart';
import '../models/waste_manager.dart';
import '../services/waste_manager_service.dart';
import '../widgets/add_waste_manager_form.dart';
import '../widgets/delete_confirmation_dialog.dart';
import '../widgets/update_waste_manager_form.dart';

class WasteManagerScreen extends StatefulWidget {
  const WasteManagerScreen({super.key});

  @override
  _WasteManagerScreenState createState() => _WasteManagerScreenState();
}

class _WasteManagerScreenState extends State<WasteManagerScreen> {
  final WasteManagerService _wasteManagerService = WasteManagerService();
  late Future<List<WasteManager>> _wasteManagers;
  List<WasteManager> _filteredWasteManagers = [];
  String _searchQuery = '';
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    _fetchManagers();
  }

  // Fetch all waste managers
  Future<void> _fetchManagers() async {
    _wasteManagers = _wasteManagerService.fetchWasteManagers();
    _wasteManagers.then((managers) {
      setState(() {
        _filteredWasteManagers = managers;
      });
    });
  }

  // Method to filter waste managers based on search query
  void _filterWasteManagers(String query) {
    _wasteManagers.then((managers) {
      setState(() {
        _searchQuery = query;
        _filteredWasteManagers = managers.where((manager) {
          return manager.username!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              manager.email.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    });
  }

  // Method to show the Update form
  void _showUpdateForm(WasteManager manager) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UpdateWasteManagerForm(manager: manager);
      },
    );
  }

  // Method to show Delete Confirmation dialog
  void _showDeleteConfirmation(String managerId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(
          onConfirm: () async {
            CommandInvoker invoker = CommandInvoker();
            invoker.setCommand(
                DeleteWasteManagerCommand(_wasteManagerService, managerId));
            await invoker.executeCommand();
            _fetchManagers(); // Refresh the list
          },
        );
      },
    );
  }

  // Method to show the form for adding a new waste manager
// Method to show the form for adding a new waste manager
  void _showAddForm() async {
    String userId = await userService.assignNextUserId();
    bool? isAdded = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddWasteManagerForm(
          manager: WasteManager(
            userId: userId,
            username: '',
            email: '',
            password: '',
            managerId: '',
            userRole: 'waste_manager',
          ),
        );
      },
    );

    // Check if a new manager was added and refresh the list
    if (isAdded == true) {
      _fetchManagers(); // Refresh the list of managers after a new one is added
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waste Manager Management'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => _filterWasteManagers(value),
              decoration: InputDecoration(
                hintText: 'Search Waste Managers',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<WasteManager>>(
        future: _wasteManagers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (_filteredWasteManagers.isEmpty) {
            return Center(child: Text('No Waste Managers found.'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  DataTable(
                    columns: [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Username')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: _filteredWasteManagers.map((wasteManager) {
                      return DataRow(cells: [
                        DataCell(Text(wasteManager.managerId ?? 'N/A')),
                        DataCell(Text(wasteManager.username ?? 'N/A')),
                        DataCell(Text(wasteManager.email ?? 'N/A')),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _showUpdateForm(
                                      wasteManager); // Show update form
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _showDeleteConfirmation(wasteManager.userId ??
                                      ''); // Handle nullable
                                },
                              ),
                            ],
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddForm,
        tooltip: 'Add Waste Manager',
        child: Icon(Icons.add),
      ),
    );
  }
}
