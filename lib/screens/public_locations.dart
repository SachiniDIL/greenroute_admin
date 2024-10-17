import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:greenroute_admin/providers/trash_bin_provider.dart';

class AddPublicLocationScreen extends StatefulWidget {
  const AddPublicLocationScreen({super.key});

  @override
  _AddPublicLocationScreenState createState() =>
      _AddPublicLocationScreenState();
}

class _AddPublicLocationScreenState extends State<AddPublicLocationScreen> {
  LatLng? _selectedLocation;
  final TextEditingController _locationNameController = TextEditingController();
  final TrashBinProvider _binProvider = TrashBinProvider();

  // Callback function for selecting a location on the map
  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
      print("Selected Location: $_selectedLocation"); // Debugging
    });
  }

  void _addPublicLocation(BuildContext context) async {
    if (_selectedLocation != null && _locationNameController.text.isNotEmpty) {
      double latitude = _selectedLocation!.latitude;
      double longitude = _selectedLocation!.longitude;
      String name = _locationNameController.text;

      print("Adding Public Location: Name: $name, Lat: $latitude, Long: $longitude"); // Debugging

      // Access the TrashBinProvider from the provider
      await _binProvider.addPublicBin(
        context: context,
        latitude: latitude,
        longitude: longitude,
        name: name,
      );

      // Clear form and map selection after adding
      setState(() {
        _selectedLocation = null;
        _locationNameController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Public Location'),
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
                    height: constraints.maxHeight * 0.5, // 50% of screen height
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(6.9271, 79.8612), // Default center (Colombo)
                        zoom: 12,
                      ),
                      onTap: _onMapTap, // When user taps on the map
                      markers: _selectedLocation != null
                          ? {
                        Marker(
                          markerId: MarkerId('selected-location'),
                          position: _selectedLocation!,
                        ),
                      }
                          : {},
                    ),
                  ),
                  SizedBox(height: 16),

                  // Location name input field
                  TextField(
                    controller: _locationNameController,
                    decoration: InputDecoration(
                      labelText: 'Location Name',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      setState(() {}); // Rebuild UI to check button enabled/disabled
                    },
                  ),
                  SizedBox(height: 16),

                  // Show selected location if available
                  if (_selectedLocation != null)
                    Text(
                      'Selected Location: (${_selectedLocation!.latitude}, ${_selectedLocation!.longitude})',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  SizedBox(height: 16),

                  // Submit button
                  ElevatedButton(
                    onPressed: _selectedLocation != null &&
                        _locationNameController.text.isNotEmpty
                        ? () => _addPublicLocation(context)
                        : null, // Disable button if conditions not met
                    child: Text('Add Public Location'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
