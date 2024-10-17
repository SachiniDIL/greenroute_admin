import 'package:greenroute_admin/models/user.dart';

class WasteManager extends Users {
  String managerId;

  WasteManager({
    required super.userId,
    required super.username,
    required super.password,
    required super.email,
    super.address,
    super.contactNumber,
    required this.managerId,
    required super.userRole,
  });

  // Method to convert a WasteManager instance to a JSON Map
  @override
  Map<String, dynamic> toJson() {
    var json = super.toJson();
    json.addAll({
      'managerId': managerId,
    });
    return json;
  }

  // Factory method to create a WasteManager instance from a JSON Map
  factory WasteManager.fromJson(Map<String, dynamic> json) {
    return WasteManager(
      userId: json['userId'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      address: json['address'],
      contactNumber: json['contactNumber'],
      managerId: json['managerId'],
      userRole: json['userRole'],
    );
  }
}
