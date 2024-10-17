import 'package:greenroute_admin/models/user.dart';

class Resident extends Users {
  String residentId;

  Resident({
    required super.userId,
    required super.username,
    required super.password,
    required super.email,
    super.address,
    super.contactNumber,
    required this.residentId,
    required super.userRole,
  });

  factory Resident.fromJson(Map<String, dynamic> json) {
    return Resident(
        userId: json['userId'],
        username: json['username'],
        password: json['password'],
        email: json['email'],
        address: json['address'],
        contactNumber: json['contactNumber'],
        residentId: json['residentId'],
        userRole: json['userRole']);
  }

  @override
  Map<String, dynamic> toJson() {
    var json = super.toJson();
    json['residentId'] = residentId;
    return json;
  }
}
