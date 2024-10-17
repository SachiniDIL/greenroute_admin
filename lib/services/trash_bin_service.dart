import 'package:greenroute_admin/api/api_client.dart';
import 'package:greenroute_admin/services/location_service.dart';
import '../models/location.dart';
import '../models/trash_bin.dart';

class TrashBinService {
  final ApiClient _apiClient = ApiClient();
  final LocationService _locationService = LocationService();

  // Get next trash bin ID
  Future<String> assignTrashBinId() async {
    // Fetch all trash bins from the Firebase database
    final trashBinData = await _apiClient.get('users/trashBin.json');

    if (trashBinData != null) {
      // Extract the list of trash bin IDs and find the highest one
      List<String> trashBinIds = [];
      trashBinData.forEach((key, value) {
        trashBinIds.add(value['binId']);
      });

      // Sort the bin IDs in ascending order
      trashBinIds.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

      // Find the next available binId by incrementing the highest one
      String nextBinId = (int.parse(trashBinIds.last) + 1).toString();

      return nextBinId;
    } else {
      // If no bins exist, start with binId "1"
      return '1';
    }
  }

  // Method to create a new trash bin
  Future<void> createTrashBin({
    required String userId,
    required double latitude,
    required double longitude,
    required String name,
    required double trashLevel,
    required String sensorData,
  }) async {
    try {
      // Get the next available trash bin ID
      String newBinId = await assignTrashBinId();

      // Create a new location for the trash bin
      await _locationService.addNewLocation(
        userId: userId,
        latitude: latitude,
        longitude: longitude,
        name: name,
        binId: newBinId,
      );

      // Create a new TrashBin object
      TrashBin newTrashBin = TrashBin(
        binId: int.parse(newBinId),
        location: Locations(
          latitude: latitude,
          longitude: longitude,
          name: name,
        ),
        trashLevel: trashLevel,
        sensorData: sensorData,
      );

      // Convert TrashBin object to JSON
      Map<String, dynamic> trashBinData = newTrashBin.toJson();

      // 1. Query the user by userId to get the Firebase key
      final userResponse = await _apiClient.get(
        'users.json?orderBy="userId"&equalTo="$userId"',
      );

      // No need to decode userResponse.body since it is already decoded
      final userData = userResponse as Map<String, dynamic>;

      // Check if user exists
      if (userData.isNotEmpty) {
        // Extract the Firebase key (unique identifier for the user)
        final firebaseUserKey = userData.keys.first;

        // 2. Use the Firebase key to save the trashBin data for that user
        await _apiClient.patch(
          'users/$firebaseUserKey/trashBin.json',
          trashBinData,
        );

        print('Trash bin created successfully');
      } else {
        throw Exception('User not found for userId: $userId');
      }
    } catch (e) {
      print('Failed to create trash bin: $e');
      throw Exception('Error creating trash bin');
    }
  }

  Future<void> createPublicBin({
    required double latitude,
    required double longitude,
    required String name,
  }) async {
    try {
      // Get the next available trash bin ID
      String newBinId = await assignTrashBinId();
      double trashLevel = 0;
      String sensorData = 'empty';

      // Create a new location for the trash bin
      await _locationService.addNewPublicLocation(
        latitude: latitude,
        longitude: longitude,
        name: name,
      );

      // Create a new TrashBin object
      TrashBin newTrashBin = TrashBin(
        binId: int.parse(newBinId),
        location: Locations(
          latitude: latitude,
          longitude: longitude,
          name: name,
        ),
        trashLevel: trashLevel,
        sensorData: sensorData,
      );

      // Convert TrashBin object to JSON
      Map<String, dynamic> trashBinData = newTrashBin.toJson();

      // Logic to save trashBinData to your database
      // await _apiClient.put('publicBins.json', trashBinData); // Example save

      print('Public trash bin created successfully');
    } catch (e) {
      print('Failed to create public trash bin: $e');
      throw Exception('Error creating public trash bin');
    }
  }
}
