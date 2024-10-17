import 'package:greenroute_admin/models/location.dart';

class TrashBin {
  int binId;
  Locations location;
  double trashLevel =0;
  String sensorData ='Empty';

  TrashBin({
    required this.binId,
    required this.location,
    required this.trashLevel,
    required this.sensorData,
  });

  factory TrashBin.fromJson(Map<String, dynamic> json) {
    return TrashBin(
      binId: json['binId'],
      location: json['location'],
      trashLevel: json['trashLevel'],
      sensorData: json['sensorData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'binId': binId,
      'location': location,
      'trashLevel': trashLevel,
      'sensorData': sensorData,
    };
  }
}
