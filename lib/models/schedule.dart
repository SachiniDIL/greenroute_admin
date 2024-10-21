import 'package:greenroute_admin/models/route.dart';

class Schedule {
  final String scheduleId;
  final String truckNumber;
  final String driverName;
  final DateTime startTime;
  final DateTime endTime;
  final Route route;
  final DateTime date;

  Schedule({
    required this.scheduleId,
    required this.truckNumber,
    required this.driverName,
    required this.startTime,
    required this.endTime,
    required this.route,
    required this.date,
  });

  // Convert JSON data to a Schedule object
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      scheduleId: json['scheduleId'],
      truckNumber: json['truckNumber'],
      driverName: json['driverName'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      route: Route.fromJson(json['route']),
      date: DateTime.parse(json['date']), // Parse date from JSON
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
      'route': route.toJson(),
      'date': date.toIso8601String(), // Include date in JSON
    };
  }
}
