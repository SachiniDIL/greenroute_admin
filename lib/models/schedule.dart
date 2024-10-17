import 'package:greenroute_admin/models/location.dart';

class Schedule {
  final int scheduleId;
  final String truckNumber;
  final String driverName;
  final DateTime startTime;
  final DateTime endTime;
  final List<Locations> routeLocations;

  Schedule({
    required this.scheduleId,
    required this.truckNumber,
    required this.driverName,
    required this.startTime,
    required this.endTime,
    required this.routeLocations,
  });

  // Convert JSON data to a Schedule object
  factory Schedule.fromJson(Map<String, dynamic> json) {
    List<Locations> locations = (json['routeLocations'] as List).map((location) => Locations.fromJson(location)).toList();

    return Schedule(
      scheduleId: json['scheduleId'],
      truckNumber: json['truckNumber'],
      driverName: json['driverName'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      routeLocations: locations,
    );
  }

  // Convert a Schedule object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'scheduleId': scheduleId,
      'truckNumber': truckNumber,
      'driverName': driverName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'routeLocations': routeLocations.map((location) => location.toJson()).toList(),
    };
  }
}
