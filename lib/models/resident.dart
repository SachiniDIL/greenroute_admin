import 'package:greenroute_admin/models/location.dart';
import 'package:greenroute_admin/models/user.dart';

class Resident extends Users {
  final String residentId; // Use final to make it immutable
  final Locations location; // Corrected variable name to singular
  final String binId; // Added bin parameter

  Resident({
    required super.userId,
    required super.username,
    required super.password,
    required super.email,
    super.address,
    super.contactNumber,
    required this.residentId,
    required super.userRole,
    required this.location, // Correctly added location
    required this.binId, // Correctly added bin
  });

  factory Resident.fromJson(Map<String, dynamic> json) {
    return Resident(
      userId: json['userId'] ?? '', // Handle null values safely
      username: json['username'] ?? '', // Handle null values safely
      password: json['password'] ?? '', // Ensure password is not null
      email: json['email'] ?? '', // Handle null values safely
      address: json['address'] ?? '', // Provide a default empty string if null
      contactNumber: json['contactNumber'] ?? '', // Provide a default empty string if null
      residentId: json['residentId'] ?? '', // Handle null values safely
      userRole: json['userRole'] ?? 'Resident', // Provide a default value if null
      location: Locations.fromJson(json['location'] ?? {}), // Parse location safely; provide default if null
      binId: json['binId'] ?? '', // Fetch bin from JSON; ensure it’s not null
    );
  }

  @override
  Map<String, dynamic> toJson() {
    var json = super.toJson();
    json['residentId'] = residentId;
    json['location'] = location.toJson(); // Serialize location to JSON
    json['binId'] = binId; // Use the correct property name for bin
    return json;
  }
}
