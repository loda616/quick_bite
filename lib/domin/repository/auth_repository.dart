import 'package:quick_bite/data/models/request/forget_password_request.dart';
import 'package:quick_bite/data/models/request/register_request_model.dart';

import '../../data/models/response/login_response_model.dart';

abstract class AuthRepository {
  // =============================================================================
  // CORE AUTHENTICATION METHODS
  // =============================================================================
  Future<LoginResponseModel> login(String email, String password);
  Future<void> register(RegisterRequestModel registerRequest);
  Future<void> forgetPassword(ForgetPasswordRequest forgetPasswordRequest);
  Future<void> logout();

  // =============================================================================
  // AUTHENTICATION STATE & VALIDATION
  // =============================================================================
  Future<bool> isLoggedIn();
  Future<bool> isFullyAuthenticated();
  bool isQuickLoggedIn();

  // =============================================================================
  // USER DATA ACCESS
  // =============================================================================
  Future<String?> getToken();
  Future<String?> getUserId();
  Future<String?> getUserName();
  Future<String?> getUserEmail();
  Future<String?> getUserRole();
  Future<Map<String, String?>> getAllUserInfo();
  String? getQuickUserName();
  String? getQuickUserEmail();
  Future<void> refreshUserDataFromToken();

  // =============================================================================
  // DEBUG & UTILITY METHODS
  // =============================================================================
  Future<bool> validateStorageConsistency();
  Future<Map<String, dynamic>> getAuthSummary();
}