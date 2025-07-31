import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';

import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';

class FoodDescription extends StatelessWidget {
  final String description;
  final AppLocalizations l10n;

  const FoodDescription({
    super.key,
    required this.description,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.description,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface, // Theme-aware color
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(0.7), // Theme-aware background
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.3), // Theme-aware border
            ),
          ),
          child: Text(
            description,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: theme.colorScheme.onSurface.withOpacity(0.8), // Theme-aware color
            ),
          ),
        ),
      ],
    );
  }
}
