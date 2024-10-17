import 'package:greenroute_admin/models/location.dart';

class Vehicle {
  int vehicleId;
  String vehicleNumber;
  double vehicleCapacity;
  String vehicleStatus;
  Locations locations;

  Vehicle({
    required this.vehicleId,
    required this.vehicleNumber,
    required this.vehicleCapacity,
    required this.vehicleStatus,
    required this.locations
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleId: json['vehicleId'],
      vehicleNumber: json['vehicleNumber'],
      vehicleCapacity: json['vehicleCapacity'],
      vehicleStatus: json['vehicleStatus'],
      locations:  json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'vehicleNumber': vehicleNumber,
      'vehicleCapacity': vehicleCapacity,
      'vehicleStatus': vehicleStatus,
    };
  }
}
