// lib/services/waste_collector_service.dart
import 'dart:convert';
import 'package:greenroute_admin/api/api_client.dart';
import 'package:greenroute_admin/models/user.dart';
import 'package:greenroute_admin/services/user_service.dart';
import 'package:http/http.dart' as http;
import '../models/waste_collector.dart';

class WasteCollectorService {
  final apiClient = ApiClient();
  final UserService _userService = UserService();
  
  // Add a new waste collector
  Future<void> addWasteCollector(WasteCollector collector) async {
    String userId = _userService.assignNextUserId() as String;
    String userRole = "waste_collector";
    
    Users newCollector = Users(userId: userId, userRole: userRole, password: null, email: email)
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
