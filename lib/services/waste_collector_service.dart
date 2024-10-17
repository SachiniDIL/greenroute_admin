// lib/services/waste_collector_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/waste_collector.dart';

class WasteCollectorService {
  final String baseUrl = 'https://example.com/api'; // Replace with your API URL

  // Add a new waste collector
  Future<WasteCollector?> addWasteCollector(WasteCollector collector) async {
    final url = Uri.parse('$baseUrl/collectors');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(collector.toJson()),
    );

    if (response.statusCode == 201) {
      return WasteCollector.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add waste collector');
    }
  }

  // Get waste collector by ID
  Future<WasteCollector?> getWasteCollector(int collectorId) async {
    final url = Uri.parse('$baseUrl/collectors/$collectorId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WasteCollector.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load waste collector');
    }
  }

  // Update waste collector
  Future<void> updateWasteCollector(WasteCollector collector) async {
    final url = Uri.parse('$baseUrl/collectors/${collector.collectorId}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(collector.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update waste collector');
    }
  }

  // Delete waste collector
  Future<void> deleteWasteCollector(int collectorId) async {
    final url = Uri.parse('$baseUrl/collectors/$collectorId');
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception('Failed to delete waste collector');
    }
  }

  getAllWasteCollectors() {}
}
