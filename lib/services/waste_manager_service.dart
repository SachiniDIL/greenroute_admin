import '../api/api_client.dart';
import '../models/waste_manager.dart';

class WasteManagerService {
  final apiClient = ApiClient();

  // Fetch waste managers from the database
  Future<List<WasteManager>> fetchWasteManagers() async {
    print("Fetching waste managers...");

    // API call to get users where the role is 'waste_manager'
    final response = await apiClient.get('users.json?orderBy="role"&equalTo="waste_manager"');

    print("Full Response from Firebase: $response");

    List<WasteManager> wasteManagers = [];

    // Loop through the response to convert each user into a WasteManager instance
    response.forEach((key, value) {
      print("Fetched Waste Manager: ${value['username']}");
      wasteManagers.add(WasteManager.fromJson(value));
    });

    print("Total Waste Managers Fetched: ${wasteManagers.length}");
    return wasteManagers;
  }

  // Add a new waste manager to the database
  Future<void> addWasteManager(WasteManager wasteManager) async {
    print("Adding new waste manager...");

    // Define the endpoint where we will add the new user in the Firebase database
    final url = 'users.json';

    try {
      // Make POST request to add the new waste manager to the database
      await apiClient.post(url, wasteManager.toJson());

      print("Waste Manager added successfully with data: ${wasteManager.toJson()}");
    } catch (e) {
      // Print error details in case of failure
      print("Error adding Waste Manager: $e");
      throw Exception('Failed to add Waste Manager');
    }
  }

  // Update waste manager in the database
  Future<void> updateWasteManager(WasteManager wasteManager) async {
    print("Updating waste manager with ID: ${wasteManager.userId}");

    // First, fetch the waste manager by userId to find the unique Firebase key
    final response = await apiClient.get('users.json?orderBy="userId"&equalTo="${wasteManager.userId}"');

    print("Firebase Response: $response");

    // Check if the response contains any user data
    if (response != null && response.isNotEmpty) {
      response.forEach((key, value) {
        // Check if the userId matches before updating
        if (value['userId'] == wasteManager.userId) {
          final url = 'users/$key.json';  // Target the specific record using the Firebase key

          print("Updating Waste Manager with Firebase Key: $key");

          // Make PUT request to update the waste manager's details
          apiClient.put(url, wasteManager.toJson());

          print("Waste Manager with ID: ${wasteManager.userId} updated successfully");
        }
      });
    } else {
      print("No Waste Manager found with ID: ${wasteManager.userId}");
      throw Exception('Waste Manager not found');
    }
  }

  // Delete waste manager from the database
  Future<void> deleteWasteManager(String userId) async {
    print("Deleting Waste Manager with ID: $userId");

    // First, fetch the waste manager by userId to get the unique key from the database
    final response = await apiClient.get('users.json?orderBy="userId"&equalTo="$userId"');

    // Loop through the response to find the record and delete it
    response.forEach((key, _) async {
      final url = 'users/$key.json';  // Use the Firebase key to target the specific record

      print("Deleting record at URL: $url");  // Debug print for the deletion URL

      // Make DELETE request to remove the waste manager from the database
      await apiClient.delete(url);

      print("Waste Manager with ID: $userId and Key: $key deleted successfully");
    });
  }
}
