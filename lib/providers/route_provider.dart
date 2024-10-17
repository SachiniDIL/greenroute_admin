// lib/providers/route_provider.dart
import 'package:flutter/material.dart';
import '../models/route.dart' as MyRoute;  // Use an alias for your model Route
import '../services/route_service.dart';

class RouteProvider extends ChangeNotifier {
  List<MyRoute.Route> _routes = [];
  final RouteService _routeService = RouteService();

  List<MyRoute.Route> get routes => _routes;

  // Fetch all routes
  Future<void> fetchRoutes() async {
    try {
      _routes = await _routeService.getAllRoutes();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  // Add a new route
  Future<void> addRoute(MyRoute.Route newRoute) async {
    try {
      final route = await _routeService.addRoute(newRoute);
      if (route != null) {
        _routes.add(route);
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  // Update a route
  Future<void> updateRoute(MyRoute.Route updatedRoute) async {
    try {
      await _routeService.updateRoute(updatedRoute);
      final index = _routes.indexWhere((route) => route.routeId == updatedRoute.routeId);
      if (index != -1) {
        _routes[index] = updatedRoute;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  // Delete a route
  Future<void> deleteRoute(int routeId) async {
    try {
      await _routeService.deleteRoute(routeId);
      _routes.removeWhere((route) => route.routeId == routeId);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
