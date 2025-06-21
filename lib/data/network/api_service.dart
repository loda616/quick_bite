import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../models/register_request_model.dart';
import '../models/user_model.dart';

part 'api_service.g.dart';

abstract class ParseErrorLogger {
  void logError(Object error, StackTrace stackTrace, RequestOptions options);
}

@RestApi(baseUrl: "http://hydra.runasp.net/")
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @POST("api/Account/Register")
  Future<UserModel> register(@Body() RegisterRequestModel registerRequest);

  @POST("api/Account/Login")
  Future<UserModel> login(@Body() Map<String, dynamic> credentials);
}