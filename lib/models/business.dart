import 'package:greenroute_admin/models/trash_bin.dart';
import 'package:greenroute_admin/models/user.dart';

class Business extends Users {
  String businessName;
  String phoneNumber;
  String businessType;
  TrashBin? trashBin; // Make it nullable

  Business({
    required this.businessName,
    required this.phoneNumber,
    required this.businessType,
    required super.userId,
    required super.userRole,
    required super.password,
    required super.email,
    this.trashBin, // Initialize trashBin
    super.address,
  });

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'businessName': businessName,
      'phoneNumber': phoneNumber,
      'businessType': businessType,
      'trashBin': trashBin?.toJson(), // Safely serialize trashBin
    });
    return json;
  }

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      businessName: json['businessName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      businessType: json['businessType'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      userId: json['userId'] ?? '',
      trashBin: json['trashBin'] != null
          ? TrashBin.fromJson(json['trashBin']) // Create TrashBin from JSON
          : null,
      // Set to null if not present
      userRole: json['userRole'] ?? '',
    );
  }
}
