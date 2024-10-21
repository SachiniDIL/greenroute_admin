import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:greenroute_admin/providers/business_provider.dart';
import 'package:greenroute_admin/providers/resident_provider.dart';
import 'package:greenroute_admin/providers/trash_bin_provider.dart';
import '../models/business.dart';
import '../models/resident.dart';
import '../models/trash_bin.dart';
import '../utils/marker_utils.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  LatLng? _selectedLocation;
  final TrashBinProvider _binProvider = TrashBinProvider();
  final ResidentProvider _residentProvider = ResidentProvider();
  final BusinessProvider _businessProvider = BusinessProvider();

  List<TrashBin> _bins = []; // To hold the fetched bins
  Set<Marker> _markers = {}; // To hold the markers
  TrashBin? _selectedBin; // To hold the currently selected bin data

  bool _showResidents = true; // Toggle state for residents/businesses
  String _searchQuery = ''; // Search query for filtering

  // Search controllers for residents and businesses
  final TextEditingController _residentSearchController = TextEditingController();
  final TextEditingController _businessSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBins(); // Fetch bins when the screen is initialized
    _residentProvider.fetchResidents(); // Fetch residents
    _businessProvider.fetchBusinesses(); // Fetch businesses
  }

  Future<void> _fetchBins() async {
    print("Fetching all bins...");
    List<TrashBin> publicBins = await _binProvider.getAllPublicBins();
    List<TrashBin> businessBins = await _binProvider.getAllBusinessBins();

    // Combine both bin lists
    setState(() {
      _bins = [...publicBins, ...businessBins]; // Combine both lists
    });

    print("Fetched ${_bins.length} bins (public + business)"); // Debugging
    await _updateMarkers();
  }

  Future<void> _updateMarkers() async {
    print("Updating markers...");
    Set<Marker> newMarkers = {};
    for (TrashBin bin in _bins) {
      Marker marker =
      await createMarker(bin); // Await the custom marker creation
      newMarkers.add(marker);
    }

    // Add selected location marker if available
    if (_selectedLocation != null) {
      newMarkers.add(await createMarker(null, location: _selectedLocation!));
    }

    setState(() {
      _markers = newMarkers; // Update markers on the map
    });
    print("Markers updated. Total markers: ${_markers.length}"); // Debugging
  }

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
      print("Selected Location: $_selectedLocation"); // Debugging
    });
    _updateMarkers(); // Update markers to reflect the new selected location
  }

  void _onMarkerTapped(TrashBin bin) {
    setState(() {
      _selectedBin = bin; // Update the selected bin
    });
  }

  void _toggleTables() {
    setState(() {
      _showResidents = !_showResidents; // Switch the table view
      _searchQuery = ''; // Reset the search query when toggling
      _residentSearchController.clear();
      _businessSearchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Screen'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Map widget in a fixed-height container
                  SizedBox(
                    height: 400,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(6.9271, 79.8612),
                        // Default center (Colombo)
                        zoom: 12,
                      ),
                      onTap: _onMapTap, // When user taps on the map
                      markers: _markers, // Use dynamically created markers
                      onMapCreated: (GoogleMapController controller) {},
                    ),
                  ),
                  SizedBox(height: 16),

                  // Toggle Button
                  ElevatedButton(
                    onPressed: _toggleTables,
                    child: Text(
                        _showResidents ? 'Show Businesses' : 'Show Residents'),
                  ),
                  SizedBox(height: 16),

                  // Show selected location if available
                  if (_selectedLocation != null)
                    Text(
                      'Selected Location: (${_selectedLocation!.latitude}, ${_selectedLocation!.longitude})',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  SizedBox(height: 16),

                  // Search Bar based on toggle state
                  if (_showResidents)
                    _buildSearchBar(
                      controller: _residentSearchController,
                      hint: 'Search Residents',
                      onChanged: (query) {
                        setState(() {
                          _searchQuery = query;
                        });
                      },
                    )
                  else
                    _buildSearchBar(
                      controller: _businessSearchController,
                      hint: 'Search Businesses',
                      onChanged: (query) {
                        setState(() {
                          _searchQuery = query;
                        });
                      },
                    ),
                  SizedBox(height: 16),

                  // Display either residents or businesses based on the toggle state
                  if (_showResidents) ...[
                    Text(
                      'Residents',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    _buildResidentsTable(), // Resident table
                  ] else ...[
                    Text(
                      'Businesses',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    _buildBusinessesTable(), // Business table
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Build Search Bar Widget
  Widget _buildSearchBar(
      {required TextEditingController controller,
        required String hint,
        required Function(String) onChanged}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      onChanged: onChanged,
    );
  }

  // Build table for residents
  Widget _buildResidentsTable() {
    return FutureBuilder<List<Resident>>(
      future: _residentProvider.fetchResidents(), // Fetch residents
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No residents found.');
        }

        final residents = snapshot.data!.where((resident) {
          return resident.username
              !.toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
              resident.email.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

        return DataTable(
          columns: [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Bin ID')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Location Name')),
            DataColumn(label: Text('Actions')),
          ],
          rows: residents.map((resident) {
            return DataRow(cells: [
              DataCell(Text('${resident.username}')),
              DataCell(Text(resident.binId ?? 'N/A')),
              DataCell(Text(resident.email ?? 'N/A')),
              DataCell(Text(resident.location.name)),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showUpdateResidentDialog(resident),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () =>
                        _confirmDeleteResident(resident.userId),
                  ),
                ],
              )),
            ]);
          }).toList(),
        );
      },
    );
  }

  // Build table for businesses
  Widget _buildBusinessesTable() {
    return FutureBuilder<List<dynamic>>(
        future: _businessProvider.fetchBusinesses(), // Fetch businesses
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
    return Text('Error: ${snapshot.error}');
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
    return Text('No businesses found.');
    }

    final businesses = snapshot.data!.where((business) {
      return business.businessName
          .toLowerCase()
          .contains(_searchQuery.toLowerCase()) ||
          business.email.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return DataTable(
      columns: [
        DataColumn(label: Text('Business Name')),
        DataColumn(label: Text('Type')),
        DataColumn(label: Text('Location Name')),
        DataColumn(label: Text('Bin ID')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Actions')),
      ],
      rows: businesses.map((business) {
        return DataRow(cells: [
          DataCell(Text(business.businessName ?? 'N/A')),
          DataCell(Text(business.businessType ?? 'N/A')),
          DataCell(Text(business.trashBin?.location.name ?? 'N/A')),
          DataCell(Text(business.trashBin?.binId ?? 'N/A')),
          DataCell(Text(business.email ?? 'N/A')),
          DataCell(Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _showUpdateBusinessDialog(business),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _confirmDeleteBusiness(business.userId),
              ),
            ],
          )),
        ]);
      }).toList(),
    );
    },
    );
  }

  void _confirmDeleteResident(String residentId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this resident?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _residentProvider
                    .deleteResident(residentId); // Delete resident
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteBusiness(String businessId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this business?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _businessProvider
                    .deleteBusiness(businessId); // Delete business
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateResidentDialog(Resident resident) {
    final formKey = GlobalKey<FormState>();
    String? username = resident.username;
    String email = resident.email;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Resident'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: username,
                  decoration: InputDecoration(labelText: 'Username'),
                  onChanged: (value) {
                    username = value; // Update username
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: email,
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (value) {
                    email = value; // Update email
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState?.validate() == true) {
                  // If the form is valid
                  Resident updatedResident = Resident(
                    userId: resident.userId,
                    username: username,
                    password: resident.password,
                    email: email,
                    address: resident.address,
                    contactNumber: resident.contactNumber,
                    residentId: resident.residentId,
                    userRole: resident.userRole,
                    location: resident.location,
                    binId: resident.binId,
                  );

                  await _residentProvider.updateResident(updatedResident);
                  Navigator.of(context).pop(); // Close dialog
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateBusinessDialog(Business business) {
    final formKey = GlobalKey<FormState>();
    String businessName = business.businessName;
    String email = business.email;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Business'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: businessName,
                  decoration: InputDecoration(labelText: 'Business Name'),
                  onChanged: (value) {
                    businessName = value; // Update business name
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a business name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: email,
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (value) {
                    email = value; // Update email
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState?.validate() == true) {
                  // If the form is valid
                  Business updatedBusiness = Business(
                    userId: business.userId,
                    businessName: businessName,
                    phoneNumber: business.phoneNumber,
                    businessType: business.businessType,
                    email: email,
                    password: business.password,
                    address: business.address,
                    trashBin: business.trashBin,
                    userRole: 'business',
                  );

                  await _businessProvider.updateBusiness(updatedBusiness);
                  Navigator.of(context).pop(); // Close dialog
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}

