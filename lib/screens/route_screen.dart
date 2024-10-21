import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/trash_bin.dart';

class RoutesScreen extends StatefulWidget {
  final List<List<TrashBin>> routes; // Accept routes as a parameter

  const RoutesScreen({super.key, required this.routes}); // Constructor to accept routes

  @override
  _RoutesScreenState createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  final Set<Marker> _markers = {};
  final List<Polyline> _polylines = [];

  @override
  void initState() {
    super.initState();
    _createPolylines(); // Create polylines for the routes
    _createMarkers(); // Create markers for the bins
  }

  void _createPolylines() {
    for (var route in widget.routes) {
      List<LatLng> points = route.map((bin) {
        return LatLng(bin.location.latitude, bin.location.longitude);
      }).toList();

      _polylines.add(Polyline(
        polylineId: PolylineId(route.first.binId),
        points: points,
        color: Colors.blue, // You can vary colors per route
        width: 4,
      ));
    }
  }

  void _createMarkers() {
    for (var route in widget.routes) {
      for (var bin in route) {
        _markers.add(Marker(
          markerId: MarkerId(bin.binId), // Unique marker ID
          position: LatLng(bin.location.latitude, bin.location.longitude),
          infoWindow: InfoWindow(
            title: 'Bin ID: ${bin.binId}',
            snippet: 'Trash Level: ${bin.trashLevel}%',
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Garbage Collection Routes'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(6.9271, 79.8612), // Default center (Colombo)
          zoom: 12,
        ),
        polylines: Set<Polyline>.of(_polylines),
        markers: _markers, // Add markers to the map
      ),
    );
  }
}
