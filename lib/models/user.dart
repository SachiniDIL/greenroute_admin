class Users {
  String userId;
  String userRole;
  String? username;
  String? password;
  String email;
  String? address;
  String? contactNumber;

  Users({
    required this.userId,
    required this.userRole,
    this.username,
    required this.password,
    required this.email,
    this.address,
    this.contactNumber,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      userId: json['userId'] ?? '', // Assuming userId is part of the JSON
      userRole: json['role'] ?? '',
      username: json['username'] ?? '', // Optional
      password: json['password'] ?? '', // Usually, password should not be retrieved
      email: json['email'] ?? '',
      address: json['address'],
      contactNumber: json['contactNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'role': userRole,
      'username': username,
      'password': password,
      'email': email,
      'address': address,
      'contactNumber': contactNumber,
    };
  }
}
