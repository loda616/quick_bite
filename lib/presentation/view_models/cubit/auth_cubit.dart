import 'package:bloc/bloc.dart';
import 'package:quick_bite/data/models/request/forget_password_request.dart';
import 'package:quick_bite/data/models/request/register_request_model.dart';
import 'package:quick_bite/presentation/view_models/stats/auth_stat.dart';
import 'dart:developer' as developer;

import '../../../core/utilz/jwt_helper.dart';
import '../../../domin/repository/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthState());

  void _clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  // Check authentication status on app start
  Future<void> checkAuthStatus() async {
    try {
      developer.log('Checking auth status...');
      final isLoggedIn = await _authRepository.isLoggedIn();
      developer.log('Is logged in: $isLoggedIn');

      if (isLoggedIn) {
        final token = await _authRepository.getToken();
        final userId = await _authRepository.getUserId();

        // Extract user info from JWT token
        String? userName;
        if (token != null) {
          userName = JwtHelper.getUserName(token);
        }

        developer.log('User ID: $userId');
        developer.log('User Name: $userName');

        emit(state.copyWith(
          isAuthenticated: true,
          userId: userId,
          userName: userName,
        ));
      }
    } catch (e, stackTrace) {
      developer.log('Error checking auth status: $e', stackTrace: stackTrace);
      emit(const AuthState());
    }
  }

  Future<void> login(String email, String password) async {
    try {
      developer.log('Starting login process for email: $email');
      _clearError();
      emit(state.copyWith(isLoading: true));

      final loginResponse = await _authRepository.login(email, password);
      developer.log('Login successful, token received');

      // Extract user info from JWT token
      final userId = JwtHelper.getUserId(loginResponse.token);
      final userName = JwtHelper.getUserName(loginResponse.token);

      emit(state.copyWith(
        isAuthenticated: true,
        userId: userId,
        userEmail: email, // We know the email from login
        userName: userName,
        isLoading: false,
      ));
    } catch (e, stackTrace) {
      developer.log('Login error: $e', error: e, stackTrace: stackTrace);
      emit(state.copyWith(
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        isLoading: false,
      ));
    }
  }

  Future<void> logout() async {
    try {
      developer.log('Starting logout process...');
      _clearError();
      await _authRepository.logout();
      developer.log('Logout successful');
      emit(const AuthState()); // Reset to initial state
    } catch (e, stackTrace) {
      developer.log('Logout error: $e', error: e, stackTrace: stackTrace);
      emit(state.copyWith(
          errorMessage: 'Logout error: ${e.toString()}'
      ));
    }
  }

  Future<void> register(String email, String password, String fName, String lName, String phone) async {
    try {
      developer.log('Starting registration process for email: $email');
      _clearError();
      emit(state.copyWith(isLoading: true));

      final registerRequest = RegisterRequestModel(
        fName: fName,
        lName: lName,
        phone: phone,
        email: email,
        password: password,
      );

      await _authRepository.register(registerRequest);
      developer.log('Registration successful');

      emit(state.copyWith(
        isLoading: false,
        successMessage: 'Registration successful! Please login to continue.',
      ));
    } catch (e, stackTrace) {
      developer.log('Registration error: $e', error: e, stackTrace: stackTrace);
      emit(state.copyWith(
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        isLoading: false,
      ));
    }
  }

  Future<void> forgetPassword(String email) async {
    try {
      developer.log('Starting forget password process for email: $email');
      _clearError();
      emit(state.copyWith(isLoading: true));

      final forgetPasswordRequest = ForgetPasswordRequest(
        email: email,
        localURL: 'http://localhost:4200/reset-password',
      );

      await _authRepository.forgetPassword(forgetPasswordRequest);
      developer.log('Forget password successful');

      emit(state.copyWith(
        isLoading: false,
        successMessage: 'Password reset email sent successfully!',
      ));
    } catch (e, stackTrace) {
      developer.log('Forget password error: $e', error: e, stackTrace: stackTrace);
      emit(state.copyWith(
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        isLoading: false,
      ));
    }
  }

  void clearMessages() {
    emit(state.copyWith(
      errorMessage: null,
      successMessage: null,
    ));
  }
}