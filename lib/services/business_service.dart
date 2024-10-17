import 'package:greenroute_admin/services/trash_bin_service.dart';
import 'package:greenroute_admin/services/user_service.dart';
import '../api/api_client.dart';

class BusinessService {
  final ApiClient _apiClient = ApiClient();
  final UserService _userService = UserService();
  final TrashBinService _trashBinService = TrashBinService();

  // Endpoint path
  final String businessEndpoint = "/users.json";

  // Method to register a new business
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
    try {
      // First, assign the next available userId
      String userId = await _userService.assignNextUserId();

      // Create the business data
      Map<String, dynamic> businessData = {
        'businessName': businessName,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
        'businessType': businessType,
        'address': address,
        'userId': userId,
      };

      // Post the business data to Firebase
      await _apiClient.post(businessEndpoint, businessData);
      print('Business registered successfully');

      // After registering the business, create the trash bin for the user
      await _trashBinService.createTrashBin(
        userId: userId,
        latitude: latitude,
        longitude: longitude,
        name: locationName,
        trashLevel: trashLevel,
        sensorData: sensorData,
      );

      print('Trash bin created for the business');
    } catch (e) {
      print('Failed to register business or create trash bin: $e');
      throw Exception('Error registering business or creating trash bin');
    }
  }

  // Method to fetch all businesses
  Future<List<dynamic>> fetchBusinesses() async {
    try {
      final response = await _apiClient.get(businessEndpoint);
      if (response is Map<String, dynamic>) {
        return response.values.toList(); // Return a list of businesses
      }
      return [];
    } catch (e) {
      print('Failed to fetch businesses: $e');
      throw Exception('Error fetching businesses');
    }
  }

  // Method to update a business
  Future<void> updateBusiness(
    String businessId,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      await _apiClient.put('/businesses/$businessId.json', updatedData);
      print('Business updated successfully');
    } catch (e) {
      print('Failed to update business: $e');
      throw Exception('Error updating business');
    }
  }

  // Method to delete a business by ID
  Future<void> deleteBusiness(String businessId) async {
    try {
      await _apiClient.delete('/businesses/$businessId.json');
      print('Business deleted successfully');
    } catch (e) {
      print('Failed to delete business: $e');
      throw Exception('Error deleting business');
    }
  }
}
