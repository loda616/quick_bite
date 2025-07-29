import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';

class RegistrationForm extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First Name
        TextFormField(
          controller: firstNameController,
          decoration: InputDecoration(
            labelText: l10n.firstName,
            prefixIcon: const Icon(Icons.person_outline),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.pleaseEnterFirstName;
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),

        // Last Name
        TextFormField(
          controller: lastNameController,
          decoration: InputDecoration(
            labelText: l10n.lastName,
            prefixIcon: const Icon(Icons.person_outline),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.pleaseEnterLastName;
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),

        // Email
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: l10n.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.pleaseEnterEmail;
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return l10n.pleaseEnterValidEmail;
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),

        // Phone
        TextFormField(
          controller: phoneController,
          decoration: InputDecoration(
            labelText: l10n.phoneNumber,
            prefixIcon: const Icon(Icons.phone_outlined),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.pleaseEnterPhone;
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),

        // Password
        TextFormField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: l10n.password,
            prefixIcon: const Icon(Icons.lock_outlined),
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.pleaseEnterPassword;
            }
            if (value.length < 6) {
              return l10n.passwordMinLength;
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),

        // Confirm Password
        TextFormField(
          controller: confirmPasswordController,
          decoration: InputDecoration(
            labelText: l10n.confirmPassword,
            prefixIcon: const Icon(Icons.lock_outlined),
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.pleaseConfirmPassword;
            }
            return null;
          },
          onFieldSubmitted: (_) => onSubmit(),
        ),
      ],
    );
  }
}