import 'package:json_annotation/json_annotation.dart';

class LoginResponseModel {
  final String token;
  final String expiration;

  LoginResponseModel({
    required this.token,
    required this.expiration,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] as String,
      expiration: json['expiration'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'expiration': expiration,
    };
  }

  // Helper getter for expiration as DateTime
  DateTime get expirationDateTime => DateTime.parse(expiration);
}
