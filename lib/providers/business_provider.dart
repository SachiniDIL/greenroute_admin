import 'package:flutter/material.dart';
import '../services/business_service.dart';

class BusinessProvider with ChangeNotifier {
  final BusinessService _businessService = BusinessService();

  List<dynamic> _businesses = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters for business data and loading state
  List<dynamic> get businesses => _businesses;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // Method to fetch businesses from the service and notify listeners
  Future<void> fetchBusinesses() async {
    _setLoading(true);
    try {
      _businesses = await _businessService.fetchBusinesses();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
      notifyListeners(); // Notifies the listeners about the state change
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
    _setLoading(true);
    try {
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
      _errorMessage = null;
      await fetchBusinesses(); // Refresh the list after a successful registration
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Method to update an existing business and refresh the business list
  Future<void> updateBusiness(
      String businessId, Map<String, dynamic> updatedData) async {
    _setLoading(true);
    try {
      await _businessService.updateBusiness(businessId, updatedData);
      _errorMessage = null;
      await fetchBusinesses(); // Refresh the list after an update
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Method to delete a business and refresh the business list
  Future<void> deleteBusiness(String businessId) async {
    _setLoading(true);
    try {
      await _businessService.deleteBusiness(businessId);
      _errorMessage = null;
      await fetchBusinesses(); // Refresh the list after a deletion
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Private method to set loading state and notify listeners
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners(); // Triggers UI updates when loading state changes
  }
}
