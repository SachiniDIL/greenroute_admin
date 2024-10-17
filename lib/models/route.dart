// lib/models/route.dart

import 'package:greenroute_admin/models/location.dart';

class Route {
  String routeId;
  Locations startLocation;
  Locations endLocation;
  List<Locations> intermediateStops;

  Route({
    required this.routeId,
    required this.startLocation,
    required this.endLocation,
    required this.intermediateStops,
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      routeId: json['routeId'],
      startLocation: json['startLocation'],
      endLocation: json['endLocation'],
      intermediateStops: List<Locations>.from(json['intermediateStops']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'routeId': routeId,
      'startLocation': startLocation,
      'endLocation': endLocation,
      'intermediateStops': intermediateStops,
    };
  }
}
