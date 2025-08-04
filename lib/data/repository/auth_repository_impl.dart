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

      // Check if the response is successful
      if (response.response.statusCode != 200) {
        final errorData = response.response.data;
        print('=== LOGIN FAILED ===');
        print('Status Code: ${response.response.statusCode}');
        print('Error Data: $errorData');
        
        // Handle different error status codes
        switch (response.response.statusCode) {
          case 400:
            throw Exception('Invalid email or password format');
          case 401:
            throw Exception('Invalid email or password');
          case 404:
            throw Exception('Login endpoint not found');
          case 500:
            throw Exception('Server error occurred');
          default:
            throw Exception('Login failed with status ${response.response.statusCode}');
        }
      }

      final responseData = response.response.data;
      if (responseData == null || responseData is! Map<String, dynamic>) {
        throw Exception('Login failed: Invalid response format from server');
      }

      // Validate that required fields exist in the response
      if (!responseData.containsKey('token') || !responseData.containsKey('expiration')) {
        print('=== INVALID RESPONSE FORMAT ===');
        print('Response Data: $responseData');
        throw Exception('Login failed: Server response missing required fields (token, expiration)');
      }

      // Parse the login response
      LoginResponseModel loginResponse;
      try {
        print('=== PARSING LOGIN RESPONSE ===');
        loginResponse = LoginResponseModel.fromJson(responseData);
        print('✓ Parsed login response successfully');
        print('Token length: ${loginResponse.token.length}');
        print('Expiration: ${loginResponse.expiration}');
      } catch (parseError) {
        print('=== PARSING ERROR ===');
        print('Parse error: $parseError');
        print('Response Data: $responseData');
        throw Exception('Failed to parse login response: $parseError');
      }

      // Extract user info from JWT token
      try {
        print('=== EXTRACTING USER INFO FROM JWT ===');
        final userId = JwtHelper.getUserId(loginResponse.token);
        final userName = JwtHelper.getUserName(loginResponse.token);
        final userRole = JwtHelper.getUserRole(loginResponse.token);

        print('User ID: $userId');
        print('User Name: $userName');
        print('User Role: $userRole');

        // Save all authentication data at once (both secure and quick access)
        await _secureStorage.saveAuthenticationData(
          token: loginResponse.token,
          expiration: loginResponse.expirationDateTime,
          userId: userId,
          userName: userName,
          userEmail: email, // Save the email used for login
          userRole: userRole,
        );

        print('✓ Authentication data saved successfully');

      } catch (jwtError) {
        print('=== JWT PARSING ERROR ===');
        print('JWT error: $jwtError');

        // Still save the token even if JWT parsing fails, but with minimal data
        await _secureStorage.saveAuthenticationData(
          token: loginResponse.token,
          expiration: loginResponse.expirationDateTime,
          userEmail: email,
        );
      }

      return loginResponse;

    } on DioException catch (dioError) {
      print('=== DIO EXCEPTION ===');
      print('Status Code: ${dioError.response?.statusCode}');
      print('Response Data: ${dioError.response?.data}');
      print('Error Message: ${dioError.message}');

      // Handle DioException errors (network issues, timeouts, etc.)
      switch (dioError.response?.statusCode) {
        case 400:
          // Bad request - usually invalid credentials
          final errorDetail = dioError.response?.data?.toString() ?? 'Invalid request format';
          throw Exception('Invalid email or password: $errorDetail');
        case 401:
          throw Exception('Invalid email or password');
        case 404:
          throw Exception('Login service not available');
        case 500:
          final errorDetail = dioError.response?.data?.toString() ?? 'Server error';
          throw Exception('Server error: $errorDetail');
        case null:
          // Network error (no response received)
          throw Exception('Network error: Unable to connect to server. Please check your internet connection.');
        default:
          final errorDetail = dioError.response?.data?.toString() ?? dioError.message ?? 'Unknown error';
          throw Exception('Login failed: $errorDetail');
      }
    } catch (e) {
      print('=== GENERAL ERROR ===');
      print('Error: $e');
      
      // If it's already our custom exception, rethrow it
      if (e.toString().startsWith('Exception: ')) {
        rethrow;
      }
      
      // Otherwise, wrap it in a generic error
      throw Exception('Login failed: ${e.toString()}');
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

  // =============================================================================
  // FAST AUTHENTICATION CHECKS
  // =============================================================================

  /// Quick login check using SharedPreferences (very fast)
  bool isQuickLoggedIn() {
    return _secureStorage.isQuickLoggedIn();
  }

  /// Get quick user info for immediate UI display
  String? getQuickUserName() {
    return _secureStorage.getQuickUserName();
  }

  String? getQuickUserEmail() {
    return _secureStorage.getQuickUserEmail();
  }

  /// Comprehensive authentication check (validates token)
  @override
  Future<bool> isLoggedIn() async {
    return await _secureStorage.hasValidToken();
  }

  /// Validate token without JWT parsing (faster)
  Future<bool> hasValidTokenFast() async {
    // Quick check first
    if (!isQuickLoggedIn()) return false;

    // Check if token exists and hasn't expired
    final token = await _secureStorage.getToken();
    if (token == null) {
      await _secureStorage.clearAll();
      return false;
    }

    // Quick expiration check from secure storage
    final expiration = await _secureStorage.getTokenExpiration();
    if (expiration != null && DateTime.now().isAfter(expiration)) {
      await _secureStorage.clearAll();
      return false;
    }

    return true;
  }

  /// Full authentication validation (includes JWT parsing)
  Future<bool> isFullyAuthenticated() async {
    if (!await hasValidTokenFast()) return false;

    // Additional JWT validation if needed
    final token = await _secureStorage.getToken();
    if (token != null && JwtHelper.isTokenExpired(token)) {
      await _secureStorage.clearAll();
      return false;
    }

    return true;
  }

  // =============================================================================
  // DATA ACCESS METHODS
  // =============================================================================

  @override
  Future<String?> getToken() async {
    return await _secureStorage.getToken();
  }

  @override
  Future<String?> getUserId() async {
    return await _secureStorage.getUserId();
  }

  /// Get user name from secure storage
  Future<String?> getUserName() async {
    return await _secureStorage.getUserName();
  }

  /// Get user email from secure storage
  Future<String?> getUserEmail() async {
    return await _secureStorage.getUserEmail();
  }

  /// Get user role from secure storage
  Future<String?> getUserRole() async {
    return await _secureStorage.getUserRole();
  }

  /// Get all user information at once
  Future<Map<String, String?>> getAllUserInfo() async {
    return await _secureStorage.getAllUserInfo();
  }

  // =============================================================================
  // UTILITY METHODS
  // =============================================================================

  /// Refresh user data from token (if token was updated externally)
  Future<void> refreshUserDataFromToken() async {
    final token = await getToken();
    if (token == null) return;

    try {
      final userId = JwtHelper.getUserId(token);
      final userName = JwtHelper.getUserName(token);
      final userRole = JwtHelper.getUserRole(token);

      // Update stored user data
      if (userId != null) await _secureStorage.saveUserId(userId);
      if (userName != null) {
        await _secureStorage.saveUserName(userName);
        await _secureStorage.saveQuickUserInfo(userName: userName);
      }
      if (userRole != null) await _secureStorage.saveUserRole(userRole);

    } catch (e) {
      print('Error refreshing user data from token: $e');
    }
  }

  /// Validate data consistency between SharedPreferences and SecureStorage
  Future<bool> validateStorageConsistency() async {
    return await _secureStorage.validateDataConsistency();
  }

  /// Get authentication summary for debugging
  Future<Map<String, dynamic>> getAuthSummary() async {
    return {
      'isQuickLoggedIn': isQuickLoggedIn(),
      'hasToken': await getToken() != null,
      'hasUserId': await getUserId() != null,
      'quickUserName': getQuickUserName(),
      'lastLoginTime': _secureStorage.getLastLoginTime()?.toIso8601String(),
      'isFullyAuthenticated': await isFullyAuthenticated(),
    };
  }
}
