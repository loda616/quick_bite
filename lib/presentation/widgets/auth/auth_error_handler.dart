import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/core/routs/routes.dart';
import 'package:quick_bite/presentation/view_models/cubit/auth_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/auth_stat.dart';

class AuthErrorHandler {
  static void handleAuthState(BuildContext context, AuthState state) {
    if (state.errorMessage != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage!),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
      context.read<AuthCubit>().clearMessages();
    }

    if (state.successMessage != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.successMessage!),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
      context.read<AuthCubit>().clearMessages();
    }

    // Navigate to main screen when authenticated
    if (state.isAuthenticated && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.main,
            (route) => false,
      );
    }
  }
}