import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';

class TermsCheckbox extends StatelessWidget {
  final AppLocalizations l10n;
  final bool accepted;
  final VoidCallback onToggle;

  const TermsCheckbox({
    super.key,
    required this.l10n,
    required this.accepted,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: accepted,
          onChanged: (value) => onToggle(),
          activeColor: AppTheme.primaryColor,
        ),
        Expanded(
          child: GestureDetector(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: RichText(
                text: TextSpan(
                  text: l10n.iAgreeToThe,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: l10n.termsConditions,
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(text: l10n.and),
                    TextSpan(
                      text: l10n.privacyPolicy,
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
