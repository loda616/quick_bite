import 'package:flutter/material.dart';
import '../../../../core/routs/routes.dart';
import '../../../core/theme/app_theme.dart';
import 'terms_checkbox.dart';

class RegistrationActions extends StatelessWidget {
  final bool acceptedTerms;
  final VoidCallback onTermsToggle;
  final VoidCallback onRegister;
  final bool isLoading;

  const RegistrationActions({
    super.key,
    required this.acceptedTerms,
    required this.onTermsToggle,
    required this.onRegister,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Terms and Conditions
        TermsCheckbox(
          accepted: acceptedTerms,
          onToggle: onTermsToggle,
        ),
        const SizedBox(height: 24),

        // Create Account Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isLoading ? null : onRegister,
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 24),

        // Sign In Link
        TextButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.auth,
              (route) => false,
            );
          },
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              text: 'Already have an account? ',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
              children: [
                TextSpan(
                  text: 'Sign In',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}