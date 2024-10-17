// lib/services/route_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/route.dart';

class RouteService {
  final String baseUrl = 'https://example.com/api'; // Replace with your API URL

  // Add a new route
  Future<Route?> addRoute(Route route) async {
    final url = Uri.parse('$baseUrl/routes');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(route.toJson()),
    );

    if (response.statusCode == 201) {
      return Route.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add route');
    }
  }

  // Get route by ID
  Future<Route?> getRoute(int routeId) async {
    final url = Uri.parse('$baseUrl/routes/$routeId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Route.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load route');
    }
  }

  // Update route information
  Future<void> updateRoute(Route route) async {
    final url = Uri.parse('$baseUrl/routes/${route.routeId}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(route.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update route');
    }
  }

  // Delete a route
  Future<void> deleteRoute(int routeId) async {
    final url = Uri.parse('$baseUrl/routes/$routeId');
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception('Failed to delete route');
    }
  }

  // Get all routes
  Future<List<Route>> getAllRoutes() async {
    final url = Uri.parse('$baseUrl/routes');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Route.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load routes');
    }
  }
}
