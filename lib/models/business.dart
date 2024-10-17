import 'package:greenroute_admin/models/trash_bin.dart';
import 'package:greenroute_admin/models/user.dart';

class Business extends Users {
  String businessName;
  String phoneNumber;
  String businessType;
  TrashBin? trashBin;

  Business({
    required this.businessName,
    required this.phoneNumber,
    required this.businessType,
    required super.userId,
    required super.userRole,
    required super.password,
    required super.email,
    required trashBin,
    super.address
  });

  // Convert Business instance to a JSON Map
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'businessName': businessName,
      'phoneNumber': phoneNumber,
      'businessType': businessType,
      'trashBin' : trashBin
    });
    return json;
  }

  // Create a Business instance from a Map
  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      businessName: json['businessName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      businessType: json['businessType'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      userId: json['userId'] ?? '',
      trashBin: json['trashBin'] ?? '',
      userRole: json['userRole'] ?? '',
    );
  }
}
