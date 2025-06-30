import 'package:flutter/material.dart';
import 'name_fields_row.dart';
import 'form_text_field.dart';
import 'password_field.dart';

class RegistrationForm extends StatefulWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onSubmit;

  const RegistrationForm({
    super.key,
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
          firstNameController: widget.firstNameController,
          lastNameController: widget.lastNameController,
        ),
        const SizedBox(height: 16),

        // Email Field
        FormTextField(
          controller: widget.emailController,
          labelText: 'Email Address',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                .hasMatch(value.trim())) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Phone Field
        FormTextField(
          controller: widget.phoneController,
          labelText: 'Phone Number',
          prefixIcon: Icons.phone_outlined,
          hintText: '+1 (555) 123-4567',
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your phone number';
            }
            if (value.trim().length < 10) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Password Field
        PasswordField(
          controller: widget.passwordController,
          labelText: 'Password',
          isVisible: _passwordVisible,
          onVisibilityToggle: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Confirm Password Field
        PasswordField(
          controller: widget.confirmPasswordController,
          labelText: 'Confirm Password',
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
              return 'Please confirm your password';
            }
            return null;
          },
        ),
      ],
    );
  }
}