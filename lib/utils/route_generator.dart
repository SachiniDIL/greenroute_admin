import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:greenroute_admin/models/trash_bin.dart';
import 'package:greenroute_admin/providers/trash_bin_provider.dart';

class RouteGenerator {
  final TrashBinProvider binProvider;

  RouteGenerator(this.binProvider);

  // Function to calculate distance between two LatLng points
  double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371.0; // in km
    double dLat = _degreesToRadians(point2.latitude - point1.latitude);
    double dLon = _degreesToRadians(point2.longitude - point1.longitude);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(point1.latitude)) *
            cos(_degreesToRadians(point2.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // distance in km
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  // Function to generate routes based on trash levels
  Future<List<List<TrashBin>>> generateRoutes() async {
    List<TrashBin> allPublicBins = await binProvider.getAllPublicBins();
    List<TrashBin> highLevelPublicBins = allPublicBins
        .where((bin) => bin.trashLevel > 75)
        .toList();

    List<TrashBin> allBusinessBins = await binProvider.getAllBusinessBins();
    List<TrashBin> highLevelBusinessBins = allBusinessBins
        .where((bin) => bin.trashLevel > 75)
        .toList();

    List<TrashBin> highLevelBins = [...highLevelPublicBins, ...highLevelBusinessBins];

    List<List<TrashBin>> routes = [];
    List<TrashBin> currentRoute = [];

    for (var bin in highLevelBins) {
      if (currentRoute.isEmpty) {
        currentRoute.add(bin);
      } else {
        double distance = _calculateDistance(
            LatLng(currentRoute.last.location.latitude,
                currentRoute.last.location.longitude),
            LatLng(bin.location.latitude, bin.location.longitude));

        if (distance <= 2.0) {
          currentRoute.add(bin);
        } else {
          routes.add(currentRoute);
          currentRoute = [bin]; // Start a new route with the current bin
        }

        // If the route exceeds 10 bins, add it to routes
        if (currentRoute.length == 10) {
          routes.add(currentRoute);
          currentRoute = []; // Reset for next route
        }
      }
    }

    // Add the last route if it has bins
    if (currentRoute.isNotEmpty) {
      routes.add(currentRoute);
    }

    return routes;
  }
}
