import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routs/routes.dart' show AppRoutes;
import '../../../core/theme/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../view_models/cubit/auth_cubit.dart';
import '../../view_models/stats/auth_stat.dart';
import '../../widgets/auth/auth_error_handler.dart';
import '../../widgets/auth/registration/registration_actions.dart';
import '../../widgets/auth/registration/registration_form.dart';
import '../../widgets/auth/registration/registration_header.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final l10n = AppLocalizations.of(context)!;

    if (_formKey.currentState!.validate()) {
      if (!_acceptedTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.acceptTermsError),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.passwordMismatchError),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      FocusScope.of(context).unfocus();
      await context.read<AuthCubit>().register(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _phoneController.text.trim(),
      );
    }
  }

  void _toggleTermsAcceptance() {
    setState(() {
      _acceptedTerms = !_acceptedTerms;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) => AuthErrorHandler.handleAuthState(context, state),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.createAccount),
            backgroundColor: AppTheme.getBackgroundColor(context),
            foregroundColor: AppTheme.getTextColor(context),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.auth,
                      (route) => false,
                );
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RegistrationHeader(l10n: l10n),
                    const SizedBox(height: 32),
                    RegistrationForm(
                      l10n: l10n,
                      firstNameController: _firstNameController,
                      lastNameController: _lastNameController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      onSubmit: _register,
                    ),
                    const SizedBox(height: 20),
                    RegistrationActions(
                      l10n: l10n,
                      acceptedTerms: _acceptedTerms,
                      onTermsToggle: _toggleTermsAcceptance,
                      onRegister: _register,
                      isLoading: state.isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}