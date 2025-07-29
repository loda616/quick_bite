import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/view_models/cubit/auth_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/auth_stat.dart';

import '../../widgets/auth/auth_error_handler.dart';
import '../../widgets/auth/login/login_footer.dart';
import '../../widgets/auth/login/login_form.dart';
import '../../widgets/auth/login/login_header.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) => AuthErrorHandler.handleAuthState(context, state),
      builder: (context, state) {
        return const Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginHeader(),
                  SizedBox(height: 32),
                  LoginForm(),
                  SizedBox(height: 24),
                  LoginFooter(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}