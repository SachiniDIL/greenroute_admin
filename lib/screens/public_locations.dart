import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:greenroute_admin/providers/trash_bin_provider.dart';
import '../models/trash_bin.dart';
import '../utils/marker_utils.dart';

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
  List<TrashBin> _bins = []; // To hold the fetched bins
  Set<Marker> _markers = {}; // To hold the markers
  TrashBin? _selectedBin; // To hold the currently selected bin data

  @override
  void initState() {
    super.initState();
    _fetchBins(); // Fetch bins when the screen is initialized
  }

  // Fetch both public and business bins and update the state
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

  // Update the markers on the map
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

  // Callback function for selecting a location on the map
  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
      print("Selected Location: $_selectedLocation"); // Debugging
    });
    _updateMarkers(); // Update markers to reflect the new selected location
  }

  // Handle marker tap to update selected bin data
  void _onMarkerTapped(TrashBin bin) {
    setState(() {
      _selectedBin = bin; // Update the selected bin
    });
  }

  void _addPublicLocation(BuildContext context) async {
    if (_selectedLocation != null && _locationNameController.text.isNotEmpty) {
      double latitude = _selectedLocation!.latitude;
      double longitude = _selectedLocation!.longitude;
      String name = _locationNameController.text;

      print(
          "Adding Public Location: Name: $name, Lat: $latitude, Long: $longitude"); // Debugging

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

      print("Public location added successfully.");

      // Fetch updated bins after adding a new one
      await _fetchBins();
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
                    height: constraints.maxHeight * 0.7, // 50% of screen height
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(6.9271, 79.8612),
                        // Default center (Colombo)
                        zoom: 12,
                      ),
                      onTap: _onMapTap, // When user taps on the map
                      markers: _markers, // Use dynamically created markers
                      onMapCreated: (GoogleMapController controller) {
                        // Add marker tap handling
                        for (var bin in _bins) {
                          _markers.add(
                            Marker(
                              markerId: MarkerId(bin.binId),
                              position: LatLng(bin.location.latitude,
                                  bin.location.longitude),
                              infoWindow: InfoWindow(
                                title: bin.location.name,
                                snippet: 'Trash Level: ${bin.trashLevel}%',
                              ),
                              onTap: () => _onMarkerTapped(bin),
                              // Handle marker tap
                              icon: BitmapDescriptor
                                  .defaultMarker, // Replace with custom icon if needed
                            ),
                          );
                        }
                      },
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
                      setState(
                          () {}); // Rebuild UI to check button enabled/disabled
                      print("Location name entered: $text"); // Debugging
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

                  // Show selected bin data if available
                  if (_selectedBin != null)
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bin ID: ${_selectedBin!.binId}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Location: ${_selectedBin!.location.name}'),
                          Text('Trash Level: ${_selectedBin!.trashLevel}%'),
                          Text('Sensor Data: ${_selectedBin!.sensorData}'),
                          // Add any other bin details you want to show
                        ],
                      ),
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
