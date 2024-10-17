import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart'; // For geocoding (address to coordinates)
import 'package:http/http.dart' as http;
import 'dart:convert'; // For Firebase communication

class RouteCreationScreen extends StatefulWidget {
  const RouteCreationScreen({super.key});

  @override
  _RouteCreationScreenState createState() => _RouteCreationScreenState();
}

class _RouteCreationScreenState extends State<RouteCreationScreen> {
  final LatLng _initialLocation = LatLng(6.9271, 79.8612); // Example: Colombo, Sri Lanka
  final List<LatLng> _routePoints = []; // List to store selected points on the route
  final TextEditingController _searchController = TextEditingController(); // Controller for search input
  late final MapController _mapController;
  final String firebaseUrl = 'https://greenroute-7251d-default-rtdb.firebaseio.com/routes'; // Firebase URL for storing routes

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  // Function to handle adding new points when the user taps the map or searches a location
  void _addPoint(LatLng point) {
    setState(() {
      _routePoints.add(point);
    });
  }

  // Function to search for a location by name
  Future<void> _searchLocationByName(String locationName) async {
    if (locationName.isEmpty) {
      return;
    }

    try {
      List<Location> locations = await locationFromAddress(locationName); // Get locations from the name

      if (locations.isNotEmpty) {
        LatLng searchedLocation = LatLng(locations.first.latitude, locations.first.longitude);

        setState(() {
          _addPoint(searchedLocation); // Add searched location to the route
          _mapController.move(searchedLocation, 14.0); // Move map to the searched location
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No locations found!')),
        );
      }
    } catch (e) {
      print("Error searching location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching location: $e')),
      );
    }
  }

  // Function to generate the next unique route ID
// Function to generate the next unique route ID
  Future<String> _getNextRouteId() async {
    try {
      final response = await http.get(Uri.parse('$firebaseUrl.json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>?;

        if (data == null) {
          // No routes exist yet, so we start with 'RT001'
          return 'RT001';
        }

        // Extract existing route IDs and find the last one
        final routeIds = data.keys.where((key) => key.startsWith('RT')).toList();

        if (routeIds.isEmpty) {
          // No route IDs found, start with 'RT001'
          return 'RT001';
        }

        routeIds.sort(); // Sort the route IDs to get the last one
        final lastRouteId = routeIds.last;
        final int lastIdNumber = int.parse(lastRouteId.replaceAll('RT', ''));
        final nextIdNumber = lastIdNumber + 1;

        // Format the next ID as 'RTxxx'
        return 'RT${nextIdNumber.toString().padLeft(3, '0')}';
      } else {
        throw Exception('Failed to retrieve routes. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print("Error fetching last route ID: $error");
      throw Exception('Failed to retrieve routes: $error');
    }
  }

  // Function to submit the route to Firebase
  Future<void> _submitRoute() async {
    if (_routePoints.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No route points selected!')),
      );
      return;
    }

    try {
      // Generate the next route ID
      final String newRouteId = await _getNextRouteId();

      final routeData = {
        'route': _routePoints.map((point) => {'lat': point.latitude, 'lng': point.longitude}).toList(),
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Save the route with the new route ID
      final response = await http.put(
        Uri.parse('$firebaseUrl/$newRouteId.json'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(routeData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Route successfully saved with ID $newRouteId!')),
        );
        // Clear the route points after saving
        setState(() {
          _routePoints.clear(); // Clear the points to remove the markers and polylines from the map
        });
      } else {
        throw Exception('Failed to save route');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving route: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Route'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _submitRoute, // Save the route to Firebase
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for a location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchLocationByName(_searchController.text); // Trigger search on button press
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _initialLocation,
                initialZoom: 14.0,
                onTap: (tapPosition, point) {
                  _addPoint(point); // Add a point to the route when the map is tapped
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: _routePoints.map((point) {
                    return Marker(
                      point: point,
                      width: 80.0,
                      height: 80.0,
                      child: Icon(Icons.location_on, color: Colors.red, size: 40),
                    );
                  }).toList(),
                ),
                if (_routePoints.length > 1)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _routePoints,
                        strokeWidth: 4.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitRoute,
        backgroundColor: Colors.green, // Save the route when the button is pressed
        child: Icon(Icons.save),
      ),
    );
  }
}
