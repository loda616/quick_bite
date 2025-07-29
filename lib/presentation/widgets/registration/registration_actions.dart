import 'package:flutter/material.dart';
import '../../../../core/routs/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'terms_checkbox.dart';

class RegistrationActions extends StatelessWidget {
  final AppLocalizations l10n;
  final bool acceptedTerms;
  final VoidCallback onTermsToggle;
  final VoidCallback onRegister;
  final bool isLoading;

  const RegistrationActions({
    super.key,
    required this.l10n,
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
          l10n: l10n,
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
                : Text(
              l10n.createAccount,
              style: const TextStyle(
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
            text: TextSpan(
              text: l10n.alreadyHaveAccount,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
              children: [
                TextSpan(
                  text: l10n.signIn,
                  style: const TextStyle(
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