import 'dart:io';
import 'package:dio/dio.dart';
import 'package:quick_bite/data/models/request/forget_password_request.dart';
import 'package:quick_bite/data/models/response/login_response_model.dart';
import '../../models/request/register_request_model.dart';

class ApiService {
  final Dio _dio;
  final String _baseUrl;

  ApiService(this._dio, {String? baseUrl}) 
      : _baseUrl = baseUrl ?? "http://hydra.runasp.net/";

  Future<void> register(RegisterRequestModel registerRequest) async {
    try {
      print('=== API SERVICE: REGISTER REQUEST ===');
      print('URL: ${_baseUrl}api/Account/Register');
      print('Data: ${registerRequest.toJson()}');

      await _dio.post(
        '${_baseUrl}api/Account/Register',
        data: registerRequest.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('✓ Register API call successful');
    } catch (e) {
      print('❌ Register API call failed: $e');
      rethrow;
    }
  }

  Future<LoginResponseModel> login(Map<String, dynamic> credentials) async {
    try {
      print('=== API SERVICE: LOGIN REQUEST ===');
      print('URL: ${_baseUrl}api/Account/Login');
      print('Credentials: $credentials');

      final response = await _dio.post(
        '${_baseUrl}api/Account/Login',
        data: credentials,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('✓ Login API call successful');
      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');

      return LoginResponseModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      print('❌ Login API call failed: $e');
      rethrow;
    }
  }

  Future<HttpResponse<LoginResponseModel>> loginWithResponse(Map<String, dynamic> credentials) async {
    try {
      print('=== API SERVICE: LOGIN WITH RESPONSE REQUEST ===');
      print('URL: ${_baseUrl}api/Account/Login');
      print('Credentials: $credentials');

      final response = await _dio.post(
        '${_baseUrl}api/Account/Login',
        data: credentials,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('✓ Login with response API call successful');
      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');

      final loginResponse = LoginResponseModel.fromJson(response.data as Map<String, dynamic>);
      
      return HttpResponse<LoginResponseModel>(
        loginResponse,
        response,
      );
    } catch (e) {
      print('❌ Login with response API call failed: $e');
      rethrow;
    }
  }

  Future<void> forgetPassword(ForgetPasswordRequest forgetPasswordRequest) async {
    try {
      print('=== API SERVICE: FORGET PASSWORD REQUEST ===');
      print('URL: ${_baseUrl}api/Account/ForgetPassword');
      print('Data: ${forgetPasswordRequest.toJson()}');

      await _dio.post(
        '${_baseUrl}api/Account/ForgetPassword',
        data: forgetPasswordRequest.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('✓ Forget password API call successful');
    } catch (e) {
      print('❌ Forget password API call failed: $e');
      rethrow;
    }
  }
}

class HttpResponse<T> {
  final T data;
  final Response response;

  HttpResponse(this.data, this.response);
}
