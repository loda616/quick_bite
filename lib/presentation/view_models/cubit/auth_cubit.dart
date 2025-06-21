import 'package:bloc/bloc.dart';
import 'package:quick_bite/data/models/register_request_model.dart';
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

      final user = await _apiService.login({
        "email": email,
        "password": password,
      });

      emit(state.copyWith(
        isAuthenticated: true,
        userId: user.id.toString(),
        userEmail: user.email,
        userName: '${user.fName} ${user.lName}',
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

  Future<void> register(String email, String password, String fName, String lName, String phone) async {
    try {
      _clearError();
      emit(state.copyWith(isLoading: true));

      // Create register request model
      final registerRequest = RegisterRequestModel(
        fName: fName,
        lName: lName,
        phone: phone,
        email: email,
        password: password,
      );

      // Call API
      final registeredUser = await _apiService.register(registerRequest);

      emit(state.copyWith(
        isAuthenticated: true,
        userId: registeredUser.id.toString(),
        userEmail: registeredUser.email,
        userName: '${registeredUser.fName} ${registeredUser.lName}',
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