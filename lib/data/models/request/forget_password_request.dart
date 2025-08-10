import 'package:json_annotation/json_annotation.dart';

class ForgetPasswordRequest {
  final String email;
  final String localURL;

  ForgetPasswordRequest({
    required this.email,
    required this.localURL,
  });

  factory ForgetPasswordRequest.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordRequest(
      email: json['email'] as String,
      localURL: json['localURL'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'localURL': localURL,
    };
  }
}
