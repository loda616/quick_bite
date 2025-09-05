import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/exceptions.dart';
import '../../../data/models/request/forget_password_request.dart';
import '../../../data/models/request/register_request_model.dart';
import '../../../domin/repository/auth_repository.dart';
import '../stats/auth_stat.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthState());

  // =============================================================================
  // FAST INITIALIZATION METHODS
  // =============================================================================

  /// Quick authentication check for app startup (uses SharedPreferences)
  void quickCheckAuthStatus() {
    print('=== QUICK AUTH CHECK ===');

    if (_authRepository.isQuickLoggedIn()) {
      final quickUserName = _authRepository.getQuickUserName();
      final quickUserEmail = _authRepository.getQuickUserEmail();

      print('✓ Quick auth check: User is logged in');
      print('Quick user name: $quickUserName');

      emit(state.copyWith(
        isAuthenticated: true,
        userName: quickUserName,
        userEmail: quickUserEmail,
        isLoading: false,
      ));

      // Trigger background validation
      _backgroundValidateAuth();
    } else {
      print('✓ Quick auth check: User is not logged in');
      emit(state.copyWith(
        isAuthenticated: false,
        isLoading: false,
      ));
    }
  }

  /// Background validation of authentication (thorough check)
  Future<void> _backgroundValidateAuth() async {
    try {
      print('=== BACKGROUND AUTH VALIDATION ===');

      final isFullyAuthenticated = await _authRepository.isFullyAuthenticated();

      if (!isFullyAuthenticated) {
        print('❌ Background validation failed - logging out');
        await logout();
        return;
      }

      // Refresh user data if authenticated
      await _loadUserData();
      print('✓ Background validation successful');

    } catch (e) {
      print('❌ Background validation error: $e');
      await logout();
    }
  }

  /// Load complete user data
  Future<void> _loadUserData() async {
    try {
      final userInfo = await _authRepository.getAllUserInfo();

      emit(state.copyWith(
        userName: userInfo['userName'] ?? userInfo['quickUserName'],
        userEmail: userInfo['userEmail'] ?? userInfo['quickUserEmail'],
        userId: userInfo['userId'],
        userRole: userInfo['userRole'],
      ));
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  /// Comprehensive authentication check (slower but thorough)
  Future<void> checkAuthStatus() async {
    print('=== COMPREHENSIVE AUTH CHECK ===');
    emit(state.copyWith(isLoading: true));

    try {
      final isLoggedIn = await _authRepository.isLoggedIn();

      if (isLoggedIn) {
        await _loadUserData();
        print('✓ Comprehensive auth check: User is authenticated');

        emit(state.copyWith(
          isAuthenticated: true,
          isLoading: false,
        ));
      } else {
        print('✓ Comprehensive auth check: User is not authenticated');
        emit(state.copyWith(
          isAuthenticated: false,
          isLoading: false,
          userName: null,
          userEmail: null,
          userId: null,
          userRole: null,
        ));
      }
    } catch (e) {
      print('❌ Auth check error: $e');
      emit(state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        errorMessage: 'Authentication check failed',
        userName: null,
        userEmail: null,
        userId: null,
        userRole: null,
      ));
    }
  }

  // =============================================================================
  // AUTHENTICATION ACTIONS
  // =============================================================================

  Future<void> login(String email, String password, {bool rememberMe = true}) async {
    print('=== STARTING LOGIN ===');
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final response =
          await _authRepository.login(email, password, rememberMe: rememberMe);

      // Load user data after successful login
      await _loadUserData();

      print('✓ Login successful');
      emit(state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        successMessage: 'Login successful! Welcome back.',
      ));

    } on ServerException catch (e) {
      print('❌ Login failed: ${e.message}');
      emit(state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        errorMessage: e.message, // Use the message from the custom exception
        userName: null,
        userEmail: null,
        userId: null,
        userRole: null,
      ));
    } catch (e) {
      print('❌ Login failed with unexpected error: $e');
      emit(state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        errorMessage: e.toString(),
        userName: null,
        userEmail: null,
        userId: null,
        userRole: null,
      ));
    }
  }

  Future<void> register(
      String email,
      String password,
      String firstName,
      String lastName,
      String phone,
      ) async {
    print('=== STARTING REGISTRATION ===');
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final registerRequest = RegisterRequestModel(
        fName: firstName,
        lName: lastName,
        phone: phone,
        email: email,
        password: password,
      );

      await _authRepository.register(registerRequest);

      print('✓ Registration successful');
      emit(state.copyWith(
        isLoading: false,
        successMessage: 'Registration successful! Please login to continue.',
      ));

    } catch (e) {
      print('❌ Registration failed: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> forgetPassword(String email) async {
    print('=== STARTING FORGET PASSWORD ===');
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final forgetPasswordRequest = ForgetPasswordRequest(
        email: email,
        localURL: 'quickbite://reset-password', // Deep link for password reset
      );

      await _authRepository.forgetPassword(forgetPasswordRequest);

      print('✓ Forget password successful');
      emit(state.copyWith(
        isLoading: false,
        successMessage: 'Password reset link sent to your email.',
      ));

    } catch (e) {
      print('❌ Forget password failed: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> logout() async {
    print('=== STARTING LOGOUT ===');
    emit(state.copyWith(isLoading: true));

    try {
      await _authRepository.logout();

      print('✓ Logout successful');
      emit(const AuthState()); // Reset to initial state

    } catch (e) {
      print('❌ Logout error: $e');
      // Force logout even if there's an error
      emit(const AuthState());
    }
  }

  // =============================================================================
  // UTILITY METHODS
  // =============================================================================

  /// Refresh user data from token
  Future<void> refreshUserData() async {
    try {
      await _authRepository.refreshUserDataFromToken();
      await _loadUserData();
    } catch (e) {
      print('Error refreshing user data: $e');
    }
  }

  /// Validate storage consistency
  Future<bool> validateStorageConsistency() async {
    try {
      return await _authRepository.validateStorageConsistency();
    } catch (e) {
      print('Error validating storage consistency: $e');
      return false;
    }
  }

  /// Get authentication summary for debugging
  Future<Map<String, dynamic>> getAuthSummary() async {
    try {
      return await _authRepository.getAuthSummary();
    } catch (e) {
      print('Error getting auth summary: $e');
      return {};
    }
  }

  /// Clear error and success messages
  void clearMessages() {
    emit(state.copyWith(
      errorMessage: null,
      successMessage: null,
    ));
  }

  /// Update user profile data
  void updateUserProfile({
    String? userName,
    String? userEmail,
  }) {
    emit(state.copyWith(
      userName: userName ?? state.userName,
      userEmail: userEmail ?? state.userEmail,
    ));
  }

  /// Force re-authentication (when token might be invalid)
  Future<void> forceReauth() async {
    emit(state.copyWith(isLoading: true));
    await logout();
    // User will be redirected to login screen
  }

// REMOVED THE PROBLEMATIC onChange METHOD
// The onChange method is not needed for basic functionality
// If you need to track state changes, use BlocListener in your widgets instead
}