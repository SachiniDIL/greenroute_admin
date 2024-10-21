import 'package:flutter/material.dart';
import 'package:greenroute_admin/models/resident.dart';
import 'package:greenroute_admin/services/resident_service.dart';

class ResidentProvider with ChangeNotifier {
  final ResidentService _residentService = ResidentService(); // Initialize the resident service
  List<Resident> _residents = []; // Private list to hold resident data
  bool _isLoading = false; // Loading state

  // Public getter for residents
  List<Resident> get residents => _residents;
  // Public getter for loading state
  bool get isLoading => _isLoading;

  // Fetch all residents
  Future<List<Resident>> fetchResidents() async {
    _setLoading(true); // Set loading to true
    print("Fetching all residents..."); // Debug print to indicate fetching started

    try {
      _residents = await _residentService.fetchResidents(); // Use the service to fetch residents
      print("Total residents fetched: ${_residents.length}"); // Debug print for total residents fetched
      notifyListeners(); // Notify listeners about changes
      return _residents; // Return the fetched list
    } catch (error) {
      print("Error fetching residents: $error"); // Debug print for errors
      throw Exception('Failed to load residents: $error'); // Throw an exception for the caller to handle
    } finally {
      _setLoading(false); // Set loading to false after operation is complete
      print("Finished fetching residents."); // Debug print to indicate fetching finished
    }
  }

  // Fetch residents by binId
  Future<List<Resident>> fetchResidentsByBinId(String binId) async {
    print("Fetching residents for binId: $binId..."); // Debug print to indicate fetching for a specific binId

    try {
      List<Resident> residentsByBin = await _residentService.fetchResidentByBinId(binId); // Use the service to fetch residents by binId
      print("Total residents found for binId $binId: ${residentsByBin.length}"); // Debug print for total residents found
      return residentsByBin; // Return the filtered list
    } catch (error) {
      print("Error fetching residents by binId: $error"); // Debug print for errors
      throw Exception('Failed to load residents by binId: $error'); // Throw an exception for the caller to handle
    }
  }

  // Create a new resident
  Future<void> createResident(Resident resident) async {
    print("Creating resident: ${resident.username}..."); // Debug print to indicate creation started

    try {
      Resident newResident = await _residentService.createResident(resident); // Use the service to create a resident
      _residents.add(newResident); // Add newly created resident to the list
      print("Resident created: ${newResident.username}"); // Debug print for created resident
      notifyListeners(); // Notify listeners about changes
    } catch (error) {
      print("Error creating resident: $error"); // Debug print for errors
      throw Exception('Failed to create resident: $error'); // Throw an exception for the caller to handle
    }
  }

  // Update an existing resident
  Future<void> updateResident(Resident resident) async {
    print("Updating resident: ${resident.username}..."); // Debug print to indicate update started

    try {
      await _residentService.updateResident(resident); // Use the service to update the resident
      int index = _residents.indexWhere((r) => r.residentId == resident.residentId); // Find index of resident to update
      if (index != -1) {
        _residents[index] = resident; // Update resident in the list
        print("Resident updated: ${resident.username}"); // Debug print for updated resident
        notifyListeners(); // Notify listeners about changes
      } else {
        print("Resident not found for update: ${resident.residentId}"); // Debug print if resident not found
      }
    } catch (error) {
      print("Error updating resident: $error"); // Debug print for errors
      throw Exception('Failed to update resident: $error'); // Throw an exception for the caller to handle
    }
  }

  // Delete a resident
  Future<void> deleteResident(String residentId) async {
    print("Deleting resident with ID: $residentId..."); // Debug print to indicate deletion started

    try {
      await _residentService.deleteResident(residentId); // Use the service to delete the resident
      _residents.removeWhere((r) => r.residentId == residentId); // Remove resident from the list
      print("Resident deleted with ID: $residentId"); // Debug print for successful deletion
      notifyListeners(); // Notify listeners about changes
    } catch (error) {
      print("Error deleting resident: $error"); // Debug print for errors
      throw Exception('Failed to delete resident: $error'); // Throw an exception for the caller to handle
    }
  }

  // Private method to set loading state and notify listeners
  void _setLoading(bool value) {
    _isLoading = value; // Set loading state
    notifyListeners(); // Triggers UI updates when loading state changes
    print("Loading state changed to: $value"); // Debug print for loading state change
  }
}
