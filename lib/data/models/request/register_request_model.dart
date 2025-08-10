import 'package:json_annotation/json_annotation.dart';

class RegisterRequestModel {
  final String fName;
  final String lName;
  final String phone;
  final String email;
  final String password;

  RegisterRequestModel({
    required this.fName,
    required this.lName,
    required this.phone,
    required this.email,
    required this.password,
  });

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterRequestModel(
      fName: json['fName'] as String,
      lName: json['lName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fName': fName,
      'lName': lName,
      'phone': phone,
      'email': email,
      'password': password,
    };
  }
}
