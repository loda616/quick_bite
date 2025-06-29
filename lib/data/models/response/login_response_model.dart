import 'package:json_annotation/json_annotation.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  final String token;
  final String expiration;

  LoginResponseModel({
    required this.token,
    required this.expiration,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);

  // Helper getter for expiration as DateTime
  DateTime get expirationDateTime => DateTime.parse(expiration);
}