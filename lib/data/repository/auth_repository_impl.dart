import 'package:dio/dio.dart';
import 'package:quick_bite/data/models/request/forget_password_request.dart';
import '../../core/utilz/jwt_helper.dart';
import '../../domin/repository/auth_repository.dart';
import '../datasources/local/secure_storage_service.dart';
import '../datasources/remote/api_service.dart';
import '../models/request/register_request_model.dart';
import '../models/response/login_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;
  final SecureStorageService _secureStorage;

  AuthRepositoryImpl(this._apiService, this._secureStorage);

  @override
  Future<LoginResponseModel> login(String email, String password) async {
    try {
      print('=== STARTING LOGIN REQUEST ===');
      print('Email: $email');

      final credentials = {
        "email": email,
        "password": password,
      };

      final response = await _apiService.loginWithResponse(credentials);

      print('=== LOGIN RESPONSE RECEIVED ===');
      print('Status Code: ${response.response.statusCode}');
      print('Response Data: ${response.response.data}');
      print('===============================');

      // Check if the response is successful
      if (response.response.statusCode != 200) {
        final errorData = response.response.data;
        throw Exception('Login failed with status ${response.response.statusCode}: ${errorData.toString()}');
      }

      final responseData = response.response.data;
      if (responseData == null) {
        throw Exception('Login failed: No data received from server');
      }

      // Parse the login response
      LoginResponseModel loginResponse;
      try {
        print('=== PARSING LOGIN RESPONSE ===');
        print('Response data: $responseData');

        loginResponse = LoginResponseModel.fromJson(responseData as Map<String, dynamic>);

        print('✓ Parsed login response successfully');
        print('Token length: ${loginResponse.token.length}');
        print('Expiration: ${loginResponse.expiration}');
        print('==============================');

      } catch (parseError) {
        print('=== PARSING ERROR ===');
        print('Parse error: $parseError');
        print('Raw response: $responseData');
        print('====================');
        throw Exception('Failed to parse login response: $parseError');
      }

      // Extract user info from JWT token
      try {
        print('=== EXTRACTING USER INFO FROM JWT ===');
        final userId = JwtHelper.getUserId(loginResponse.token);
        final userName = JwtHelper.getUserName(loginResponse.token);

        print('User ID: $userId');
        print('User Name: $userName');
        print('=====================================');

        // Save authentication data
        await _secureStorage.saveToken(loginResponse.token);
        await _secureStorage.saveTokenExpiration(loginResponse.expirationDateTime);

        if (userId != null) {
          await _secureStorage.saveUserId(userId);
        }

        print('✓ Authentication data saved successfully');

      } catch (jwtError) {
        print('=== JWT PARSING ERROR ===');
        print('JWT error: $jwtError');
        print('Token: ${loginResponse.token}');
        print('========================');
        // Still save the token even if JWT parsing fails
        await _secureStorage.saveToken(loginResponse.token);
        await _secureStorage.saveTokenExpiration(loginResponse.expirationDateTime);
      }

      return loginResponse;

    } on DioException catch (dioError) {
      print('=== DIO EXCEPTION ===');
      print('Status Code: ${dioError.response?.statusCode}');
      print('Response Data: ${dioError.response?.data}');
      print('Request Data: ${dioError.requestOptions.data}');
      print('=====================');

      switch (dioError.response?.statusCode) {
        case 400:
          throw Exception('Invalid email or password format');
        case 401:
          throw Exception('Invalid email or password');
        case 404:
          throw Exception('Login endpoint not found');
        case 500:
          final errorDetail = dioError.response?.data?.toString() ?? 'Server error';
          throw Exception('Server error (500): $errorDetail');
        default:
          throw Exception('Network error: ${dioError.message}');
      }
    } catch (e) {
      print('=== GENERAL ERROR ===');
      print('Error: $e');
      print('Error type: ${e.runtimeType}');
      print('====================');
      rethrow;
    }
  }

  @override
  Future<void> register(RegisterRequestModel registerRequest) async {
    try {
      print('=== STARTING REGISTRATION ===');
      print('Registration data: ${registerRequest.toJson()}');

      await _apiService.register(registerRequest);
      print('✓ Registration successful');
    } on DioException catch (dioError) {
      print('=== REGISTRATION ERROR ===');
      print('Status Code: ${dioError.response?.statusCode}');
      print('Response Data: ${dioError.response?.data}');

      switch (dioError.response?.statusCode) {
        case 400:
          final errorDetail = dioError.response?.data?.toString() ?? 'Invalid registration data';
          throw Exception('Registration failed: $errorDetail');
        case 409:
          throw Exception('Email already exists');
        case 500:
          final errorDetail = dioError.response?.data?.toString() ?? 'Server error';
          throw Exception('Server error: $errorDetail');
        default:
          throw Exception('Registration failed: ${dioError.message}');
      }
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> forgetPassword(ForgetPasswordRequest forgetPasswordRequest) async {
    try {
      await _apiService.forgetPassword(forgetPasswordRequest);
    } on DioException catch (dioError) {
      switch (dioError.response?.statusCode) {
        case 404:
          throw Exception('Email not found');
        case 500:
          final errorDetail = dioError.response?.data?.toString() ?? 'Server error';
          throw Exception('Server error: $errorDetail');
        default:
          throw Exception('Failed to send reset email: ${dioError.message}');
      }
    } catch (e) {
      throw Exception('Forget password failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    await _secureStorage.clearAll();
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.getToken();
    if (token == null) return false;

    // Check token expiration using JWT helper
    if (JwtHelper.isTokenExpired(token)) {
      await _secureStorage.clearAll();
      return false;
    }

    return true;
  }

  @override
  Future<String?> getToken() async {
    return await _secureStorage.getToken();
  }

  @override
  Future<String?> getUserId() async {
    return await _secureStorage.getUserId();
  }

  // Add method to get user name from token
  Future<String?> getUserName() async {
    final token = await _secureStorage.getToken();
    if (token == null) return null;
    return JwtHelper.getUserName(token);
  }
}