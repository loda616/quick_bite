import 'package:flutter/material.dart';
import 'package:quick_bite/l10n/generated/app_localizations.dart' show AppLocalizations;

import '../../../../core/routs/routes.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Divider
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[300])),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.or,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey[300])),
          ],
        ),
        const SizedBox(height: 24),

        // Sign Up Link
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.register);
          },
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: l10n.dontHaveAccount,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
              children: [
                TextSpan(
                  text: l10n.signUp,
                  style: const TextStyle(
                    color: Color(0xFFFF6B00),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Demo Credentials (for testing)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.demoCredentials,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.demoEmail,
                style: TextStyle(color: Colors.blue[700]),
              ),
              Text(
                l10n.demoPassword,
                style: TextStyle(color: Colors.blue[700]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}