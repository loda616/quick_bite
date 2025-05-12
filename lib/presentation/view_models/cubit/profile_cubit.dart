import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/view_models/stats/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true));
    try {
      // TODO: Replace with actual profile loading logic
      await Future.delayed(const Duration(seconds: 1));
      emit(const ProfileState(
        name: "John Doe",
        email: "john.doe@example.com",
        phone: "+1234567890",
        address: "123 Main St, City",
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: "Failed to load profile"));
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
      // TODO: Replace with actual profile update logic
      await Future.delayed(const Duration(seconds: 1));
      emit(ProfileState(
        name: name ?? state.name,
        email: email ?? state.email,
        phone: phone ?? state.phone,
        address: address ?? state.address,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: "Failed to update profile"));
    }
  }
}