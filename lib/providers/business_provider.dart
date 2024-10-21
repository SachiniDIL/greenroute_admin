import 'package:flutter/material.dart';
import 'package:greenroute_admin/models/business.dart';
import '../services/business_service.dart';

class BusinessProvider with ChangeNotifier {
  final BusinessService _businessService = BusinessService(); // Initialize the BusinessService

  List<dynamic> _businesses = []; // Private list to hold business data
  bool _isLoading = false; // Loading state
  String? _errorMessage; // To hold any error messages

  // Getters for business data and loading state
  List<dynamic> get businesses => _businesses; // Public getter for the list of businesses

  bool get isLoading => _isLoading; // Public getter for loading state

  String? get errorMessage => _errorMessage; // Public getter for error message

  // Method to fetch businesses from the service and notify listeners
  Future<List> fetchBusinesses() async {
    _setLoading(true); // Set loading to true
    print("Fetching businesses..."); // Debug print for starting fetch

    try {
      // Attempt to fetch the list of businesses
      _businesses = await _businessService.fetchBusinesses();
      _errorMessage = null; // Clear any previous error message
      print("Fetched ${_businesses.length} businesses."); // Debug print for number of businesses fetched
      return _businesses; // Return the list of businesses
    } catch (e) {
      // Capture error message if fetching fails
      _errorMessage = e.toString();
      print("Error fetching businesses: $_errorMessage"); // Debug print for error
      return []; // Return an empty list on error
    } finally {
      _setLoading(false); // Set loading to false regardless of success or failure
      notifyListeners(); // Notify listeners about the state change
    }
  }

  // Method to register a new business and refresh the business list
  Future<void> registerBusiness({
    required String businessName,
    required String email,
    required String password,
    required String phoneNumber,
    required String businessType,
    required String address,
    required double latitude,
    required double longitude,
    required String locationName,
    required double trashLevel,
    required String sensorData,
  }) async {
    _setLoading(true); // Set loading to true
    print("Registering new business: $businessName..."); // Debug print for business registration

    try {
      // Attempt to register a new business
      await _businessService.registerBusiness(
        businessName: businessName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        businessType: businessType,
        address: address,
        latitude: latitude,
        longitude: longitude,
        locationName: locationName,
        trashLevel: trashLevel,
        sensorData: sensorData,
      );
      _errorMessage = null; // Clear any previous error message
      print("Business registered successfully."); // Debug print for successful registration
      await fetchBusinesses(); // Refresh the list after a successful registration
    } catch (e) {
      // Capture error message if registration fails
      _errorMessage = e.toString();
      print("Error registering business: $_errorMessage"); // Debug print for error
    } finally {
      _setLoading(false); // Set loading to false regardless of success or failure
      notifyListeners(); // Notify listeners about the state change
    }
  }

  // Method to update an existing business and refresh the business list
  Future<void> updateBusiness(Business business) async {
    _setLoading(true); // Set loading to true
    print("Updating business with ID: ${business.userId}..."); // Debug print for business update

    try {
      // Attempt to update the business
      await _businessService.updateBusiness(business);
      _errorMessage = null; // Clear any previous error message
      print("Business with ID ${business.userId} updated successfully."); // Debug print for successful update
      await fetchBusinesses(); // Refresh the list after an update
    } catch (e) {
      // Capture error message if update fails
      _errorMessage = e.toString();
      print("Error updating business: $_errorMessage"); // Debug print for error
    } finally {
      _setLoading(false); // Set loading to false regardless of success or failure
      notifyListeners(); // Notify listeners about the state change
    }
  }

  // Method to delete a business and refresh the business list
  Future<void> deleteBusiness(String businessId) async {
    _setLoading(true); // Set loading to true
    print("Deleting business with ID: $businessId..."); // Debug print for business deletion

    try {
      // Attempt to delete the business
      await _businessService.deleteBusiness(businessId);
      _errorMessage = null; // Clear any previous error message
      print("Business with ID $businessId deleted successfully."); // Debug print for successful deletion
      await fetchBusinesses(); // Refresh the list after a deletion
    } catch (e) {
      // Capture error message if deletion fails
      _errorMessage = e.toString();
      print("Error deleting business: $_errorMessage"); // Debug print for error
    } finally {
      _setLoading(false); // Set loading to false regardless of success or failure
      notifyListeners(); // Notify listeners about the state change
    }
  }

  // Method to get a business user by bin ID
  Future<Business?> getBusinessUserByBin(String binId) async {
    _setLoading(true); // Set loading to true
    print("Fetching business user for bin ID: $binId..."); // Debug print for fetching business by bin ID

    try {
      // Fetch the user data for the specified bin ID
      final userData = await _businessService.getBusinessByBinId(binId);
      _setLoading(false); // Set loading to false
      print("Fetched business user data for bin ID: $binId."); // Debug print for successful fetch
      return userData; // Return the fetched user data
    } catch (e) {
      // Capture error message if fetching fails
      print("Error fetching business user by bin ID: $e"); // Debug print for error
      _setLoading(false); // Set loading to false
      return null; // Return null in case of an error
    }
  }

  // Private method to set loading state and notify listeners
  void _setLoading(bool value) {
    _isLoading = value; // Set loading state
    notifyListeners(); // Triggers UI updates when loading state changes
  }
}
