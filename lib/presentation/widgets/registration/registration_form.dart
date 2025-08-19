import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'name_fields_row.dart';
import 'form_text_field.dart';
import 'password_field.dart';

class RegistrationForm extends StatefulWidget {
  final AppLocalizations l10n;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onSubmit;

  const RegistrationForm({
    super.key,
    required this.l10n,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onSubmit,
  });

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Name Fields Row
        NameFieldsRow(
          l10n: widget.l10n,
          firstNameController: widget.firstNameController,
          lastNameController: widget.lastNameController,
        ),
        const SizedBox(height: 16),

        // Email Field
        FormTextField(
          l10n: widget.l10n,
          controller: widget.emailController,
          labelText: widget.l10n.emailAddress,
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return widget.l10n.pleaseEnterEmail;
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                .hasMatch(value.trim())) {
              return widget.l10n.pleaseEnterValidEmail;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Phone Field
        FormTextField(
          l10n: widget.l10n,
          controller: widget.phoneController,
          labelText: widget.l10n.phoneNumber,
          prefixIcon: Icons.phone_outlined,
          hintText: '+1 (555) 123-4567',
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return widget.l10n.pleaseEnterPhone;
            }
            if (value.trim().length < 10) {
              return widget.l10n.pleaseEnterValidPhone;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Password Field
        PasswordField(
          l10n: widget.l10n,
          controller: widget.passwordController,
          labelText: widget.l10n.password,
          isVisible: _passwordVisible,
          onVisibilityToggle: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return widget.l10n.pleaseEnterPassword;
            }
            if (value.length < 6) {
              return widget.l10n.passwordMinLength;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Confirm Password Field
        PasswordField(
          l10n: widget.l10n,
          controller: widget.confirmPasswordController,
          labelText: widget.l10n.confirmPassword,
          isVisible: _confirmPasswordVisible,
          onVisibilityToggle: () {
            setState(() {
              _confirmPasswordVisible = !_confirmPasswordVisible;
            });
          },
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => widget.onSubmit(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return widget.l10n.pleaseConfirmPassword;
            }
            return null;
          },
        ),
      ],
    );
  }
}