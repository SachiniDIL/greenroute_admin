import 'package:greenroute_admin/models/user.dart';

class Admin extends Users {
  String adminId;

  // Constructor for Admin that calls the User constructor
  Admin({
    required super.userId,
    super.username,
    required super.password,
    required super.email,
    super.address,
    super.contactNumber,
    required this.adminId,
    required super.userRole,
  }); // Calls the parent (User) constructor

  // Factory method for Admin
  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
        userId: json['userId'],
        username: json['username'],
        password: json['password'],
        email: json['email'],
        address: json['address'],
        contactNumber: json['contactNumber'],
        adminId: json['adminId'],
        userRole: json['userRole']);
  }

  @override
  Map<String, dynamic> toJson() {
    var json = super.toJson();
    json['adminId'] = adminId;
    return json;
  }
}
