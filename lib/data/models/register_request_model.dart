import 'package:json_annotation/json_annotation.dart';

part 'register_request_model.g.dart';

@JsonSerializable()
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

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);
}