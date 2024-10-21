import 'package:greenroute_admin/api/api_client.dart';
import 'package:greenroute_admin/models/resident.dart';

class ResidentService {
  // Constructor
  ResidentService();

  // Initialize the API client for network requests
  final apiClient = ApiClient();

  // Fetch all residents
  Future<List<Resident>> fetchResidents() async {
    print("Fetching all residents..."); // Debug print indicating fetch start
    List<Resident> residents = []; // List to hold fetched residents

    try {
      // Send GET request to fetch residents with the role 'resident'
      final response = await apiClient.get('users.json?orderBy="role"&equalTo="resident"');

      // Debug print to check the API response
      print("API Response: $response");

      // Check if the response is empty
      if (response.isEmpty) {
        print("No residents found."); // Debug print indicating no residents
        return residents; // Return empty list
      }

      // Loop through the response and convert each entry to a Resident object
      response.forEach((key, value) {
        residents.add(Resident.fromJson(value)); // Convert JSON to Resident object
        print("Fetched Resident: ${value['username']}"); // Debug print for each resident fetched
      });

      print("Total Residents Fetched: ${residents.length}"); // Debug print for total residents
    } catch (error) {
      print("Error fetching residents: $error"); // Debug print for any errors
      throw Exception('Failed to load residents: $error'); // Rethrow the error for further handling
    }

    return residents; // Return the list of residents
  }

  // Fetch residents by binId
  Future<List<Resident>> fetchResidentByBinId(String binId) async {
    print("Fetching residents for binId: $binId..."); // Debug print indicating fetch for specific binId
    final response = await apiClient.get('users.json?orderBy="role"&equalTo="resident"');
    List<Resident> residents = []; // List to hold residents with specified binId

    // Check if the response is not null
    if (response != null) {
      // Loop through the response to find residents with the specified binId
      response.forEach((key, value) {
        // Check if the resident has the specified binId
        if (value['binId'] == binId) {
          residents.add(Resident.fromJson(value)); // Convert JSON to Resident object
          print("Found Resident with binId: ${value['username']}"); // Debug print for each matching resident
        }
      });
    }

    print("Total Residents Found for binId $binId: ${residents.length}"); // Debug print for total residents found
    return residents; // Return the list of residents
  }

  // Create a new resident
  Future<Resident> createResident(Resident resident) async {
    print("Creating resident: ${resident.username}..."); // Debug print indicating creation start
    final response = await apiClient.post('users.json', resident.toJson()); // Send POST request to create a resident
    print("Resident created with ID: ${response['userId']}"); // Debug print for the created resident ID
    return Resident.fromJson(response); // Convert JSON to Resident object and return
  }

// Update an existing resident
  Future<Resident> updateResident(Resident resident) async {
    print("Updating resident: ${resident.username}..."); // Debug print indicating update start

    try {
      // Step 1: Fetch all users
      final usersResponse = await apiClient.get('users.json');

      // Step 2: Find the unique key for the given residentId
      String? uniqueKey;
      usersResponse.forEach((key, value) {
        if (value['residentId'] == resident.residentId) {
          uniqueKey = key; // Found the matching residentId
        }
      });

      if (uniqueKey != null) {
        // Step 3: Construct the URL path using the unique key
        final url = 'users/$uniqueKey.json'; // Directly target the resident's specific path in the database

        // Step 4: Send PUT request to update the resident
        final response = await apiClient.put(url, resident.toJson()); // Pass the resident's data directly
        print("Resident updated: ${response['userId']}"); // Debug print for the updated resident ID
        return Resident.fromJson(response); // Convert JSON to Resident object and return
      } else {
        print("Resident with ID: ${resident.residentId} not found."); // Debug print if resident not found
        throw Exception('Resident not found');
      }
    } catch (error) {
      print("Error updating resident: $error"); // Debug print for any errors
      throw Exception('Failed to update resident: $error'); // Throw an exception for the caller to handle
    }
  }


  // Delete a resident
  Future<void> deleteResident(String residentId) async {
    print("Deleting resident with ID: $residentId..."); // Debug print indicating deletion start

    try {
      // Step 1: Fetch all users
      final usersResponse = await apiClient.get('users.json');

      // Step 2: Find the unique key for the given residentId
      String? uniqueKey;
      usersResponse.forEach((key, value) {
        if (value['userId'] == residentId) {
          uniqueKey = key; // Found the matching userId
        }
      });

      if (uniqueKey != null) {
        // Step 3: Construct the DELETE URL using the unique key
        String deleteUrl = 'users/$uniqueKey.json';

        // Step 4: Perform the DELETE request
        await apiClient.delete(deleteUrl);
        print("Resident with ID: $residentId deleted successfully."); // Debug print indicating successful deletion
      } else {
        print("Resident with ID: $residentId not found."); // Debug print if resident not found
      }
    } catch (error) {
      print("Error deleting resident: $error"); // Debug print for any errors
    }
  }


  // Fetch a specific resident by ID
  Future<Resident?> fetchResidentById(String residentId) async {
    print("Fetching resident with ID: $residentId..."); // Debug print indicating fetch for specific resident ID
    final response = await apiClient.get('users.json?orderBy="userId"&equalTo="$residentId"'); // Send GET request
    if (response != null) {
      print("Resident found: ${response['username']}"); // Debug print for the found resident
      return Resident.fromJson(response); // Convert JSON to Resident object and return
    }
    print("No resident found with ID: $residentId"); // Debug print indicating no resident found
    return null; // Return null if resident not found
  }
}
