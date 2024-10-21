import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:greenroute_admin/models/business.dart';
import 'package:greenroute_admin/providers/business_provider.dart';
import '../models/trash_bin.dart';

// Function to generate a custom marker icon (upside-down drop shape)
Future<BitmapDescriptor> getCustomMarker(double trashLevel) async {
  print("Generating custom marker for trash level: $trashLevel"); // Debugging
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint = Paint()..color = getBinColor(trashLevel);

  const double markerWidth = 60.0; // Adjusted marker width
  const double markerHeight = 70.0; // Adjusted marker height for a more pointed shape

  // Draw a custom shape
  final Path path = Path();
  path.moveTo(markerWidth / 2, markerHeight);
  path.quadraticBezierTo(markerWidth, markerHeight * 0.6, markerWidth, markerHeight / 2);
  path.quadraticBezierTo(markerWidth, 0, markerWidth / 2, 0);
  path.quadraticBezierTo(0, 0, 0, markerHeight / 2);
  path.quadraticBezierTo(0, markerHeight * 0.6, markerWidth / 2, markerHeight);
  path.close();

  canvas.drawPath(path, paint);

  // Draw inner circle - Increase the radius here
  const double circleRadius = 18.0; // Increased radius for inner circle
  canvas.drawCircle(Offset(markerWidth / 2, markerHeight * 0.4), circleRadius, Paint()..color = Colors.white);

  // Draw text inside the circle
  TextPainter textPainter = TextPainter(
    textDirection: ui.TextDirection.ltr,
  );

  // Text style
  textPainter.text = TextSpan(
    text: '${trashLevel.toInt()}%', // Display trash level as percentage
    style: TextStyle(fontSize: 14, color: Colors.black), // Adjusted font size
  );

  // Layout and paint text
  textPainter.layout();
  textPainter.paint(
    canvas,
    Offset(
      (markerWidth - textPainter.width) / 2, // Center horizontally
      (markerHeight * 0.4 - textPainter.height / 2), // Center vertically inside the circle
    ),
  );

  // End drawing and convert to bytes
  final ui.Image markerAsImage = await pictureRecorder.endRecording().toImage(
    markerWidth.toInt(),
    markerHeight.toInt(),
  );

  final ByteData? byteData = await markerAsImage.toByteData(
    format: ui.ImageByteFormat.png,
  );

  final Uint8List uint8List = byteData!.buffer.asUint8List();
  print("Custom marker generated successfully"); // Debugging
  return BitmapDescriptor.bytes(uint8List); // Use BitmapDescriptor.bytes
}

// Get hue value based on trash level (using custom colors)
Color getBinColor(double trashLevel) {
  print("Getting bin color for trash level: $trashLevel"); // Debugging
  if (trashLevel <= 25) {
    return Colors.green; // Green for low trash levels (0-25%)
  } else if (trashLevel > 25 && trashLevel <= 75) {
    return Colors.yellow; // Yellow for medium trash levels (25-75%)
  } else {
    return Colors.red; // Red for high trash levels (above 75%)
  }
}

// Reusable function to create markers
Future<Marker> createMarker(TrashBin? bin, {LatLng? location}) async {
  if (bin != null && bin.type == 'public') {
    print("Creating marker for public bin with ID: ${bin.binId}"); // Debugging
    BitmapDescriptor customIcon = await getCustomMarker(bin.trashLevel);
    return Marker(
      markerId: MarkerId(bin.binId),
      position: LatLng(bin.location.latitude, bin.location.longitude),
      infoWindow: InfoWindow(
        title: bin.location.name,
        snippet: 'Trash Level: ${bin.trashLevel}% \n SensorData: ${bin.sensorData}',
      ),
      icon: customIcon, // Use custom icon based on trash level
    );
  } else if (bin != null && bin.type != 'public') {
    print("Creating marker for business bin with ID: ${bin.binId}"); // Debugging
    BusinessProvider businessProvider = BusinessProvider();
    Business businessUser = businessProvider.getBusinessUserByBin(bin.binId) as Business;
    BitmapDescriptor customIcon = await getCustomMarker(bin.trashLevel);
    return Marker(
      markerId: MarkerId(bin.binId),
      position: LatLng(bin.location.latitude, bin.location.longitude),
      infoWindow: InfoWindow(
        title: bin.location.name,
        snippet: 'Trash Level: ${bin.trashLevel}% \n SensorData: ${bin.sensorData} \n Business: ${businessUser.businessName} \n Type: ${businessUser.businessType} \n Address: ${businessUser.address} \n Contact No: ${businessUser.phoneNumber} \n Email: ${businessUser.email}',
      ),
      icon: customIcon, // Use custom icon based on trash level
    );
  } else {
    print("Creating marker for selected location: $location"); // Debugging
    return Marker(
      markerId: MarkerId('selected-location'),
      position: location!,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure), // Default color for selected location
    );
  }
}

