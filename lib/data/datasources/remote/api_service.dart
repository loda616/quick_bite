import 'dart:io';
import 'package:dio/dio.dart';
import 'package:quick_bite/data/models/request/forget_password_request.dart';
import 'package:quick_bite/data/models/response/login_response_model.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/request/register_request_model.dart';

part 'api_service.g.dart';

abstract class ParseErrorLogger {
  void logError(Object error, StackTrace stackTrace, RequestOptions options);
}

@RestApi(baseUrl: "http://hydra.runasp.net/")
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @POST("api/Account/Register")
  Future<void> register(@Body() RegisterRequestModel registerRequest);

  @POST("api/Account/Login")
  Future<LoginResponseModel> login(@Body() Map<String, dynamic> credentials);

  @POST("api/Account/Login")
  Future<HttpResponse<LoginResponseModel>> loginWithResponse(@Body() Map<String, dynamic> credentials);

  @POST("api/Account/ForgetPassword")
  Future<void> forgetPassword(@Body() ForgetPasswordRequest forgetPasswordRequest);
}