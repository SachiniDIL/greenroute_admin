import '../api/api_client.dart';
import '../models/location.dart';
import '../models/trash_bin.dart';
import 'location_service.dart';

class TrashBinService {
  final apiClient = ApiClient();
  final LocationService _locationService = LocationService();

  Future<String> assignTrashBinId() async {
    final trashBinData = await apiClient.get('users/trashBin.json');
    print("Fetched Trash Bin Data: $trashBinData"); // Debug print

    if (trashBinData != null) {
      List<String> trashBinIds = [];
      trashBinData.forEach((key, value) {
        trashBinIds.add(value['binId'].toString());
      });

      print("Trash Bin IDs: $trashBinIds"); // Debug print

      trashBinIds.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
      final newId = (int.parse(trashBinIds.last) + 1).toString();
      print("Assigned Trash Bin ID: $newId"); // Debug print
      return newId;
    } else {
      print("No Trash Bin Data found, assigning ID: 1"); // Debug print
      return '1';
    }
  }

  Future<String> assignPublicTrashBinId() async {
    final trashBinData = await apiClient.get('publicBins.json');
    print("Fetched Public Trash Bin Data: $trashBinData"); // Debug print

    if (trashBinData != null) {
      List<String> trashBinIds = [];
      trashBinData.forEach((key, value) {
        trashBinIds.add(value['binId'].toString());
      });

      print("Public Trash Bin IDs: $trashBinIds"); // Debug print

      trashBinIds.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
      final newId = (int.parse(trashBinIds.last) + 1).toString();
      print("Assigned Public Trash Bin ID: $newId"); // Debug print
      return newId;
    } else {
      print("No Public Trash Bin Data found, assigning ID: 1"); // Debug print
      return '1';
    }
  }

  Future<void> createTrashBin({
    required String userId,
    required double latitude,
    required double longitude,
    required String name,
    required double trashLevel,
    required String sensorData,
  }) async {
    String newBinId = await assignTrashBinId();
    print("Creating Trash Bin with ID: $newBinId"); // Debug print

    await _locationService.addNewLocation(
      userId: userId,
      latitude: latitude,
      longitude: longitude,
      name: name,
      binId: newBinId,
    );

    TrashBin newTrashBin = TrashBin(
      binId: newBinId,
      location: Locations(latitude: latitude, longitude: longitude, name: name),
      trashLevel: trashLevel,
      sensorData: sensorData,
      type: 'business', // Assuming it's a business bin, can be adjusted
    );

    Map<String, dynamic> trashBinData = newTrashBin.toJson();
    print("Trash Bin Data to be saved: $trashBinData"); // Debug print

    final userResponse =
        await apiClient.get('users.json?orderBy="userId"&equalTo="$userId"');
    if (userResponse.isNotEmpty) {
      final firebaseUserKey = userResponse.keys.first;
      print("Firebase User Key: $firebaseUserKey"); // Debug print
      await apiClient.patch(
          'users/$firebaseUserKey/trashBin.json', trashBinData);
      print("Successfully updated user's Trash Bin data."); // Debug print
    } else {
      print("User not found for userId: $userId"); // Debug print
      throw Exception('User not found for userId: $userId');
    }
  }

  Future<void> createPublicBin({
    required double latitude,
    required double longitude,
    required String name,
  }) async {
    String newBinId = await assignPublicTrashBinId();
    print("Creating Public Bin with ID: $newBinId"); // Debug print

    TrashBin newTrashBin = TrashBin(
      binId: newBinId,
      location: Locations(latitude: latitude, longitude: longitude, name: name),
      trashLevel: 0,
      sensorData: 'empty',
      type: 'public',
    );

    Map<String, dynamic> trashBinData = newTrashBin.toJson();
    print("Public Trash Bin Data to be saved: $trashBinData"); // Debug print
    await apiClient.post('publicBins.json', trashBinData);
    print("Successfully created Public Bin."); // Debug print
  }

  Future<List<TrashBin>> getPublicBins() async {
    final response = await apiClient.get('publicBins.json');
    print("Fetched Public Bins: $response"); // Debug print
    List<TrashBin> publicBins = [];
    response.forEach((key, value) {
      publicBins.add(TrashBin.fromJson(value));
    });
    print("Total Public Bins retrieved: ${publicBins.length}"); // Debug print
    return publicBins;
  }

  Future<List<TrashBin>> getBusinessBins() async {
    // Fetch all users where role is "business"
    final response = await apiClient.get('users.json');
    print("Fetched All Users: $response"); // Debug print

    List<TrashBin> businessBins = [];

    // Iterate through the users and extract trashBin if available
    response.forEach((key, value) {
      if (value['role'] == 'business' && value['trashBin'] != null) {
        businessBins.add(TrashBin.fromJson(value['trashBin']));
      }
    });


    print("Total Business Bins retrieved: ${businessBins.length}"); // Debug print
    return businessBins;
  }


  Future<TrashBin?> getPublicBinById(String binId) async {
    final response = await apiClient.get('publicBins.json');
    print("Fetched Data for Bin ID: $binId"); // Debug print
    for (var value in response.values) {
      if (value['binId'] == binId) {
        print("Found Public Bin: $value"); // Debug print
        return TrashBin.fromJson(value);
      }
    }
    print("No Public Bin found for ID: $binId"); // Debug print
    return null;
  }
}
