// lib/providers/waste_collector_provider.dart
import 'package:flutter/material.dart';
import '../models/waste_collector.dart';
import '../services/waste_collector_service.dart';

class WasteCollectorProvider extends ChangeNotifier {
  List<WasteCollector> _collectors = [];
  final WasteCollectorService _wasteCollectorService = WasteCollectorService();

  List<WasteCollector> get collectors => _collectors;

  // Fetch all waste collectors
  Future<void> fetchWasteCollectors() async {
    try {
      _collectors = await _wasteCollectorService.getAllWasteCollectors();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  // Add a new waste collector
  Future<void> addWasteCollector(WasteCollector newCollector) async {
    try {
      final collector = await _wasteCollectorService.addWasteCollector(newCollector);
      if (collector != null) {
        _collectors.add(collector);
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  // Update an existing waste collector
  Future<void> updateWasteCollector(WasteCollector updatedCollector) async {
    try {
      await _wasteCollectorService.updateWasteCollector(updatedCollector);
      final index = _collectors.indexWhere((collector) => collector.collectorId == updatedCollector.collectorId);
      if (index != -1) {
        _collectors[index] = updatedCollector;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  // Delete a waste collector
  Future<void> deleteWasteCollector(int collectorId) async {
    try {
      await _wasteCollectorService.deleteWasteCollector(collectorId);
      _collectors.removeWhere((collector) => collector.collectorId == collectorId);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
