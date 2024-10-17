class Locations {
  final double latitude;
  final double longitude;
  final String name;

  Locations({
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  // Convert JSON data to a Location object
  factory Locations.fromJson(Map<String, dynamic> json) {
    return Locations(
      latitude: json['latitude'],
      longitude: json['longitude'],
      name: json['name'],
    );
  }

  // Convert a Location object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
    };
  }

  fromJson(location) {}
}
