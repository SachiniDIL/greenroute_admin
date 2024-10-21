import 'package:flutter/material.dart';
import '../models/trash_bin.dart';
import '../services/trash_bin_service.dart';
import '../utils/snack_bar_util.dart';

class TrashBinProvider extends ChangeNotifier {
  final List<TrashBin> _bins = [];
  final TrashBinService _trashBinService = TrashBinService();

  List<TrashBin> get bins => _bins;

  Future<void> addPublicBin({
    required BuildContext context,
    required double latitude,
    required double longitude,
    required String name,
  }) async {
    try {
      print("Attempting to add a public bin with name: $name, latitude: $latitude, longitude: $longitude"); // Debug print
      await _trashBinService.createPublicBin(latitude: latitude, longitude: longitude, name: name);
      SnackbarUtils.showSnackbar(context, 'Public Location added successfully');
      print("Public bin added successfully"); // Debug print
    } catch (e) {
      print("Error adding public bin: $e"); // Debug print
      SnackbarUtils.showSnackbar(context, 'Failed to add the public location');
    }
  }

  Future<TrashBin?> getPublicBinByBinId(String binId) async {
    try {
      print("Fetching public bin with ID: $binId"); // Debug print
      final bin = await _trashBinService.getPublicBinById(binId);
      if (bin != null) {
        print("Found public bin: ${bin.toJson()}"); // Debug print
      } else {
        print("No public bin found with ID: $binId"); // Debug print
      }
      return bin;
    } catch (e) {
      print("Error fetching public bin by ID: $e"); // Debug print
      return null;
    }
  }

  Future<List<TrashBin>> getAllPublicBins() async {
    try {
      print("Fetching all public bins"); // Debug print
      final bins = await _trashBinService.getPublicBins();
      print("Total public bins retrieved: ${bins.length}"); // Debug print
      return bins;
    } catch (e) {
      print("Error fetching all public bins: $e"); // Debug print
      return [];
    }
  }

  Future<List<TrashBin>> getAllBusinessBins() async {
    try {
      print("Fetching all business bins"); // Debug print
      final bins = await _trashBinService.getBusinessBins();
      print("Total business bins retrieved: ${bins.length}"); // Debug print
      return bins;
    } catch (e) {
      print("Error fetching all business bins: $e"); // Debug print
      return [];
    }
  }
}
