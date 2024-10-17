import 'package:greenroute_admin/models/user.dart';

class WasteCollector extends Users {
  int collectorId;
  String assignedRoute;

  // WasteCollector class constructor
  WasteCollector({
    required super.userId,
    required super.username,
    required super.password,
    required super.email,
    required super.address,
    required super.contactNumber,
    required this.collectorId,
    required this.assignedRoute,
    required super.userRole,
  }); // Invoking the constructor of the parent (User) class

  factory WasteCollector.fromJson(Map<String, dynamic> json) {
    return WasteCollector(
        userId: json['userId'],
        username: json['username'],
        password: json['password'],
        email: json['email'],
        address: json['address'],
        contactNumber: json['contactNumber'],
        collectorId: json['collectorId'],
        assignedRoute: json['assignedRoute'],
        userRole: json['userRole']);
  }

  @override
  Map<String, dynamic> toJson() {
    var json = super.toJson();
    json['collectorId'] = collectorId;
    json['assignedRoute'] = assignedRoute;
    return json;
  }
}
