import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';

class RegistrationHeader extends StatelessWidget {
  final AppLocalizations l10n;

  const RegistrationHeader({
    super.key,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.createAccount,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.fillDetailsToContinue,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}