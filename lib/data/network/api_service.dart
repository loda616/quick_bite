import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../models/user_model.dart';

part 'api_service.g.dart';

abstract class ParseErrorLogger {
  void logError(Object error, StackTrace stackTrace, RequestOptions options);
}

@RestApi(baseUrl: "http://localhost:5201/api/")
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @POST("Account/Register")
  Future<UserModel> register(@Body() UserModel user);

  @POST("Account/Login")
  Future<UserModel> login(@Body() Map<String, dynamic> credentials);
}