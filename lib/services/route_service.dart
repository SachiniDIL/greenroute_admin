// lib/services/route_service.dart

import 'dart:math';

import 'package:greenroute_admin/api/api_client.dart';
import 'package:greenroute_admin/models/trash_bin.dart';
import 'package:greenroute_admin/models/schedule.dart';
import 'package:greenroute_admin/services/schedule_service.dart';
import 'package:greenroute_admin/services/trash_bin_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/route.dart';
import '../models/waste_collector.dart';

class RouteService {
  final TrashBinService trashBinService;
  final ScheduleService scheduleService;
  final apiClient = ApiClient();

  RouteService(this.trashBinService, this.scheduleService);

  // Method to find the next routeId and set it to the user object
  Future<String> assignNextRouteId() async {
    // Fetch all routes from the Firebase database
    final usersData = await apiClient.get('routes.json');

    if (usersData != null) {
      // Extract the list of route IDs and find the highest one
      List<String> routeId = [];
      usersData.forEach((key, value) {
        routeId.add(value['routeId']);
      });

      // Sort the route IDs in ascending order
      routeId.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

      // Find the next available routeId by incrementing the highest one
      String nextRouteId = (int.parse(routeId.last) + 1).toString();

      // Assign the new scheduleId to the user object
      return nextRouteId;
    } else {
      // If no route exist, start with scheduleId "1"
      return '1';
    }
  }

  // Function to create routes based on trash levels
  Future<List<List<TrashBin>>> createRoutes() async {
    // Fetch public and business bins
    List<TrashBin> publicBins = await trashBinService.getPublicBins();
    List<TrashBin> businessBins = await trashBinService.getBusinessBins();

    // Combine and filter bins based on trash level
    List<TrashBin> highLevelBins = [...publicBins, ...businessBins]
        .where((bin) => bin.trashLevel > 60)
        .toList();

    List<List<TrashBin>> routes = [];
    List<TrashBin> currentRoute = [];

    for (var i = 0; i < highLevelBins.length; i++) {
      if (currentRoute.isEmpty) {
        currentRoute.add(highLevelBins[i]);
      } else {
        double distance = _calculateDistance(
          LatLng(currentRoute.last.location.latitude,
              currentRoute.last.location.longitude),
          LatLng(highLevelBins[i].location.latitude,
              highLevelBins[i].location.longitude),
        );

        if (distance <= 2.0 && currentRoute.length < 10) {
          currentRoute.add(highLevelBins[i]);
        } else {
          routes.add(currentRoute);
          currentRoute = [
            highLevelBins[i]
          ]; // Start a new route with the current bin
        }
      }
    }

    // Add the last route if it has bins
    if (currentRoute.isNotEmpty) {
      routes.add(currentRoute);
    }

    // Create schedules for the routes
    await _createSchedulesForRoutes(routes);

    return routes;
  }

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

  // Create schedules for the routes
  Future<void> _createSchedulesForRoutes(List<List<TrashBin>> routes) async {
    for (var route in routes) {
      // Fetch the earliest assigned truck and collector
      String truckNumber = await _getAvailableTruck();
      WasteCollector collector = await _getEarliestCollector();

      // Create a new schedule for tomorrow
      Schedule schedule = Schedule(
        scheduleId: await scheduleService.assignNextScheduleId(),
        truckNumber: truckNumber,
        driverName: collector.username,
        startTime: DateTime.now().add(Duration(days: 1)),
        // Start tomorrow
        endTime: DateTime.now().add(Duration(days: 1, hours: 3)),
        // Duration example
        route: Route(
          routeId: assignNextRouteId(),
          startLocation: route.first.location,
          endLocation: route.last.location,
          intermediateStops: route.map((bin) => bin.location).toList(),
        ),
        date: DateTime.now().add(Duration(days: 1)), // Schedule date
      );

      await scheduleService.createSchedule(schedule);
    }
  }

  Future<String> _getAvailableTruck() async {
    // Logic to fetch an available truck (placeholder)
    return 'Truck_1'; // Replace with actual implementation
  }

  Future<WasteCollector> _getEarliestCollector() async {
    // Logic to fetch the earliest available waste collector (placeholder)
    return WasteCollector(
        userId: 'collector_1',
        username: 'John Doe',
        password: '',
        email: '',
        address: '',
        contactNumber: '',
        collectorId: 1,
        assignedRoute: '',
        userRole: 'waste_collector'); // Replace with actual implementation
  }
}
