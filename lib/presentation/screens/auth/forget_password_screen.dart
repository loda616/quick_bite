import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/screens/auth/reset_link_sent_screen.dart';
import 'package:quick_bite/presentation/view_models/cubit/auth_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/auth_stat.dart';

import '../../../l10n/generated/app_localizations.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      await context.read<AuthCubit>().forgetPassword(_emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.errorMessage != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
          context.read<AuthCubit>().clearMessages();
        }
        if (state.successMessage != null && mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ResetLinkSentScreen(),
            ),
          );
          context.read<AuthCubit>().clearMessages();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80),

                      // Logo
                      const Image(
                        image: AssetImage('assets/images/QuickBite-logo.png'),
                      ),
                      const SizedBox(height: 40),

                      // Title
                      Text(
                        l10n.forgotPasswordTitle,
                        style: textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Description
                      Text(
                        l10n.forgotPasswordDesc,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Email Input
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: l10n.emailAddress,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.pleaseEnterEmail;
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return l10n.pleaseEnterValidEmail;
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _resetPassword(),
                      ),
                      const SizedBox(height: 24),

                      // Reset Password Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state.isLoading ? null : _resetPassword,
                          child: state.isLoading
                              ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : Text(
                            l10n.resetPassword,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Back to Login
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          l10n.backToLogin,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}