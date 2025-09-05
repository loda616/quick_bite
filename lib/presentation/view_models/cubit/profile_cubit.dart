import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/view_models/stats/profile_state.dart';
import '../../../core/utilz/jwt_helper.dart';
import '../../../domin/repository/auth_repository.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _authRepository;

  ProfileCubit(this._authRepository) : super(const ProfileState()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final token = await _authRepository.getToken();
      final userId = await _authRepository.getUserId();

      if (token == null || userId == null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: "User not logged in",
        ));
        return;
      }

      // Extract user info from JWT token
      final userName = JwtHelper.getUserName(token);
      final tokenData = JwtHelper.decodeToken(token);

      print('=== PROFILE DATA FROM JWT ===');
      print('User ID: $userId');
      print('User Name: $userName');
      print('Full token data: $tokenData');
      print('=============================');

      // For now, we'll use the data from JWT.
      // In a real app, you might want to fetch additional profile data from an API
      emit(ProfileState(
        name: userName ?? "Unknown User",
        email: "N/A", // Email not available in current JWT, would need separate API call
        phone: "N/A", // Phone not available in current JWT
        address: "N/A", // Address not available in current JWT
        isLoading: false,
      ));

    } catch (e) {
      print('Error loading profile: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: "Failed to load profile: ${e.toString()}",
      ));
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
  }) async {
    emit(state.copyWith(isLoading: true));

    try {
      // TODO: Implement actual profile update API call
      // For now, just update local state
      await Future.delayed(const Duration(seconds: 1));

      emit(ProfileState(
        name: name ?? state.name,
        email: email ?? state.email,
        phone: phone ?? state.phone,
        address: address ?? state.address,
        isLoading: false,
      ));

    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: "Failed to update profile: ${e.toString()}",
      ));
    }
  }

  Future<void> refreshProfile() async {
    await loadProfile();
  }

  Future<void> logout() async {
    await _authRepository.logout();
  }
}