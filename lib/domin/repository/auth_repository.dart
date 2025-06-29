import 'package:quick_bite/data/models/request/forget_password_request.dart';
import 'package:quick_bite/data/models/request/register_request_model.dart';

import '../../data/models/response/login_response_model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login(String email, String password);
  Future<void> register(RegisterRequestModel registerRequest);
  Future<void> forgetPassword(ForgetPasswordRequest forgetPasswordRequest);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<String?> getToken();
  Future<String?> getUserId();
}