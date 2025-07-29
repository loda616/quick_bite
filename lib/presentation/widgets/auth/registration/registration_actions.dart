import 'package:flutter/material.dart';

import '../../../../core/routs/routes.dart';
import '../../../../l10n/generated/app_localizations.dart';

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
        // Terms Checkbox
        Row(
          children: [
            Checkbox(
              value: acceptedTerms,
              onChanged: (_) => onTermsToggle(),
              activeColor: Theme.of(context).primaryColor,
            ),
            Expanded(
              child: GestureDetector(
                onTap: onTermsToggle,
                child: Text(
                  l10n.acceptTerms,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Register Button
        ElevatedButton(
          onPressed: isLoading ? null : onRegister,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
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
            l10n.register,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Already have account
        TextButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.auth,
                  (route) => false,
            );
          },
          child: Text(
            l10n.alreadyHaveAccount,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}