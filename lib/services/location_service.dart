import 'package:greenroute_admin/services/user_service.dart';

import '../api/api_client.dart';

class LocationService {
  final apiClient = ApiClient();
  final UserService _userService = UserService();

  // Method to add or update a new location for a specific user
  Future<void> addNewLocation(
      {required String userId,
      required double latitude,
      required double longitude,
      required String name,
      required String binId}) async {
    Map<String, dynamic> locationData = {
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
    };

    try {
      // Step 1: Find the user's key using userId
      final userKey = await _userService.getUserKeyByUserId(userId);

      if (userKey == null) {
        print('User not found with userId: $userId');
        return;
      }

      // Step 2: Update the location under the correct user and bin
      await apiClient.put(
          'users/$userKey/trashBin/location.json', locationData);
      print(
          'Location added/updated successfully for user $userId (key: $userKey) and bin $binId');
    } catch (e) {
      print('Failed to update location for user $userId: $e');
      throw Exception('Error adding/updating location');
    }
  }

  Future<void> addNewPublicLocation({
    required double latitude,
    required double longitude,
    required String name,
  }) async {
    Map<String, dynamic> locationData = {
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
    };

    try {
      // Assuming that 'publicLocations' is a valid path in your database
      await apiClient.post('publicLocations.json', locationData);
      print('Public location added successfully: $locationData');
    } catch (e) {
      print('Failed to add public location: $e');
      throw Exception('Error adding public location');
    }
  }

}
