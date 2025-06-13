import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:quick_bite/presentation/view_models/stats/auth_stat.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  void _clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  Future<void> login(String email, String password, BuildContext context) async {
    try {
      _clearError();
      // TODO: Implement actual login logic
      emit(state.copyWith(
        isAuthenticated: true,
        userId: "user123",
        userEmail: email,
        userName: "QuickBite User",
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: "Login failed. Please try again.",
      ));
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      _clearError();
      emit(const AuthState());
    } catch (e) {
      emit(state.copyWith(
        errorMessage: "Network error. Please try again.",
      ));
    }
  }

  Future<void> register(
      String email, String password, String name, BuildContext context) async {
    try {
      _clearError();
      // TODO: Implement actual registration logic
      emit(state.copyWith(
        isAuthenticated: true,
        userId: "user123",
        userEmail: email,
        userName: name,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: "Registration failed. Please try again.",
      ));
    }
  }
}
