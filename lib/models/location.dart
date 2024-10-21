class Locations {
  final double latitude;
  final double longitude;
  final String name;

  Locations({
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  factory Locations.fromJson(Map<String, dynamic> json) {
    return Locations(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0, // Ensure latitude is a double
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0, // Ensure longitude is a double
      name: json['name'] ?? 'Unknown', // Provide default name if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
    };
  }
}
