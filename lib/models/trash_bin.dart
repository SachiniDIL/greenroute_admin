import 'location.dart';

class TrashBin {
  String binId;
  Locations location;
  double trashLevel;
  String sensorData;
  String type;

  TrashBin({
    required this.binId,
    required this.location,
    required this.trashLevel,
    required this.sensorData,
    required this.type,
  }) {
    print("Creating TrashBin: $toJson()"); // Debug print for constructor
  }

  factory TrashBin.fromJson(Map<String, dynamic> json) {
    print("Creating TrashBin from JSON: $json"); // Debug print for fromJson
    return TrashBin(
      binId: json['binId']?.toString() ?? '0',
      location: Locations.fromJson(json['location']),
      trashLevel: json['trashLevel'] ?? 0,
      sensorData: json['sensorData'] ?? 'empty',
      type: json['type'] ?? 'public',
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'binId': binId,
      'location': location.toJson(),
      'trashLevel': trashLevel,
      'sensorData': sensorData,
      'type': type,
    };
    print("Converting TrashBin to JSON: $json"); // Debug print for toJson
    return json;
  }
}
