import 'package:bloc/bloc.dart';
import 'package:quick_bite/data/models/user_model.dart';
import 'package:quick_bite/presentation/view_models/stats/auth_stat.dart';
import '../../../data/network/api_service.dart';
import '../../../data/network/dio_client.dart';

class AuthCubit extends Cubit<AuthState> {
  final ApiService _apiService;

  AuthCubit()
      : _apiService = ApiService(DioClient.getDio()),
        super(const AuthState());

  void _clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  Future<void> login(String email, String password) async {
    try {
      _clearError();
      emit(state.copyWith(isLoading: true));

      // TODO: Implement actual login API call
      // final user = await _apiService.login(email, password);

      // For now, mock response
      await Future.delayed(const Duration(seconds: 1));

      emit(state.copyWith(
        isAuthenticated: true,
        userId: "user123",
        userEmail: email,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Login failed: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

  Future<void> logout() async {
    try {
      _clearError();
      emit(const AuthState()); // Reset to initial state
    } catch (e) {
      emit(state.copyWith(
          errorMessage: 'Logout error: ${e.toString()}'
      ));
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      _clearError();
      emit(state.copyWith(isLoading: true));

      // Create user model
      final user = UserModel(
        id: 0, // server will assign ID
        name: name,
        email: email,
      );

      // Call API
      final registeredUser = await _apiService.register(user);

      emit(state.copyWith(
        isAuthenticated: true,
        userId: registeredUser.id.toString(),
        userEmail: registeredUser.email,
        userName: registeredUser.name,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Registration Failed: ${e.toString()}',
        isLoading: false,
      ));
    }
  }
}