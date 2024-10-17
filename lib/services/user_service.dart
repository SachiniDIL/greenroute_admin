// lib/services/user_service.dart
import '../api/api_client.dart';

class UserService {
  final ApiClient _apiClient = ApiClient();

  // Method to find the next userId and set it to the user object
  Future<String> assignNextUserId() async {
    // Fetch all users from the Firebase database
    final usersData = await _apiClient.get('users.json');

    if (usersData != null) {
      // Extract the list of user IDs and find the highest one
      List<String> userIds = [];
      usersData.forEach((key, value) {
        userIds.add(value['userId']);
      });

      // Sort the user IDs in ascending order
      userIds.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

      // Find the next available userId by incrementing the highest one
      String nextUserId = (int.parse(userIds.last) + 1).toString();

      // Assign the new userId to the user object
      return nextUserId;
    } else {
      // If no users exist, start with userId "1"
      return '1';
    }
  }

  // Method to find the user's key using the userId
  Future<String?> getUserKeyByUserId(String userId) async {
    try {
      final response = await _apiClient.get('users.json?orderBy="userId"&equalTo="$userId"');
      if (response != null && response is Map<String, dynamic>) {
        // Return the first key that matches the userId
        return response.keys.first;
      }
    } catch (e) {
      print('Error retrieving user key for userId $userId: $e');
    }
    return null; // Return null if not found
  }
}
