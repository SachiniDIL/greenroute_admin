import 'package:greenroute_admin/models/business.dart';
import 'package:greenroute_admin/services/trash_bin_service.dart';
import 'package:greenroute_admin/services/user_service.dart';
import '../api/api_client.dart';

class BusinessService {
  final apiClient = ApiClient(); // API client for making HTTP requests
  final UserService _userService =
      UserService(); // Service for managing user-related operations
  final TrashBinService _trashBinService =
      TrashBinService(); // Service for trash bin operations

  // Endpoint path for business data
  final String businessEndpoint = "users.json";

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
      // Assign the next available userId
      String userId = await _userService.assignNextUserId();
      String role = 'business';

      // Create the business data as a Map
      Map<String, dynamic> businessData = {
        'businessName': businessName,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
        'businessType': businessType,
        'address': address,
        'userId': userId,
        'role': role,
      };

      // Post the business data to Firebase
      await apiClient.post(businessEndpoint, businessData);
      print('Business registered successfully with ID: $userId');

      // After registering the business, create the trash bin for the user
      await _trashBinService.createTrashBin(
        userId: userId,
        latitude: latitude,
        longitude: longitude,
        name: locationName,
        trashLevel: trashLevel,
        sensorData: sensorData,
      );

      print('Trash bin created for the business with ID: $userId');
    } catch (e) {
      print(
          'Failed to register business or create trash bin: $e'); // Print error message
      throw Exception(
          'Error registering business or creating trash bin'); // Throw a specific exception
    }
  }

  // Method to get user data by binId under users with role "business"
  Future<Business?> getBusinessByBinId(String binId) async {
    try {
      // Fetch all users with the role "business"
      final response =
          await apiClient.get('users.json?orderBy="role"&equalTo="business"');
      final users = response as Map<String, dynamic>;

      // Debug print to check the response of users
      print("Fetched users: $users");

      // Iterate through users and check if the binId matches in the trashBin
      for (var userKey in users.keys) {
        final user = users[userKey];
        if (user['trashBin'] != null && user['trashBin']['binId'] == binId) {
          print(
              "Found business for binId $binId: ${user['businessName']}"); // Debug print for found business
          return user; // Return the matching user's data
        }
      }
      return null; // Return null if no user with the matching binId is found
    } catch (e) {
      print('Failed to get user by binId: $e'); // Print error message
      throw Exception(
          'Error fetching user by binId'); // Throw a specific exception
    }
  }

  // Method to fetch all businesses
  Future<List<Business>> fetchBusinesses() async {
    print("Fetching all businesses..."); // Debug print to indicate fetching
    List<Business> businesses = []; // List to hold fetched businesses

    try {
      final response =await apiClient.get('users.json?orderBy="role"&equalTo="business"');

      // Debug print to check response
      print("API Response: $response");

      if (response.isEmpty) {
        print("No businesses found."); // Debug print for no businesses
        return businesses; // Return empty list
      }

      // Convert JSON response to Business objects
      response.forEach((key, value) {
        businesses
            .add(Business.fromJson(value)); // Convert JSON to Business object
        print(
            "Fetched Business: ${value['businessName']}"); // Debug print for each business
      });

      print(
          "Total Businesses Fetched: ${businesses.length}"); // Debug print for total businesses
    } catch (error) {
      print("Error fetching businesses: $error"); // Print error message
      throw Exception('Failed to load businesses: $error'); // Rethrow the error
    }

    return businesses; // Return the list of businesses
  }

  // Method to update a business
  // Update an existing business
  Future<Business> updateBusiness(Business business) async {
    try {
      print(
          "Updating business with ID: ${business.userId}..."); // Debug print for update

      // Step 1: Fetch all users to find the unique key
      final usersResponse = await apiClient.get('users.json');

      String? uniqueKey;
      usersResponse.forEach((key, value) {
        // Find the unique key corresponding to the business userId
        if (value['userId'] == business.userId && value['role'] == 'business') {
          uniqueKey = key; // Set the unique key if found
        }
      });

      if (uniqueKey != null) {
        // Step 2: Construct the URL path using the unique key
        final url =
            'users/$uniqueKey.json'; // Target the specific path for the business

        // Step 3: Send PUT request to update the business
        final response = await apiClient.put(
            url, business.toJson()); // Update business details
        print(
            'Business updated successfully with ID: ${response['userId']}'); // Debug print for successful update

        return Business.fromJson(
            response); // Convert JSON to Business object and return
      } else {
        print(
            "Business with ID: ${business.userId} not found."); // Debug print if business not found
        throw Exception(
            'Business not found'); // Throw an exception if not found
      }
    } catch (e) {
      print('Failed to update business: $e'); // Print error message
      throw Exception('Error updating business'); // Throw a specific exception
    }
  }

  // Method to delete a business by ID
  // Delete a business
  Future<void> deleteBusiness(String businessId) async {
    try {
      print(
          "Deleting business with ID: $businessId..."); // Debug print for deletion

      // Step 1: Fetch all users
      final usersResponse = await apiClient.get('users.json');

      // Step 2: Find the unique key for the given businessId
      String? uniqueKey;
      usersResponse.forEach((key, value) {
        if (value['userId'] == businessId && value['role'] == 'business') {
          uniqueKey = key; // Found the matching businessId
        }
      });

      if (uniqueKey != null) {
        // Step 3: Construct the URL path using the unique key
        final url =
            'users/$uniqueKey.json'; // Directly target the business's specific path in the database

        // Step 4: Send DELETE request to delete the business
        await apiClient.delete(url); // Perform the deletion
        print(
            'Business deleted successfully with ID: $businessId'); // Debug print for successful deletion
      } else {
        print(
            "Business with ID: $businessId not found."); // Debug print if business not found
        throw Exception(
            'Business not found'); // Throw an exception if not found
      }
    } catch (e) {
      print('Failed to delete business: $e'); // Print error message
      throw Exception('Error deleting business'); // Throw a specific exception
    }
  }
}
