import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';

class FoodCustomizations extends StatelessWidget {
  final List<String> options;
  final Set<String> selectedCustomizations;
  final Function(String) onToggle;
  final AppLocalizations l10n;

  const FoodCustomizations({
    super.key,
    required this.options,
    required this.selectedCustomizations,
    required this.onToggle,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.customizations,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor ,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: options.map((option) {
            final isSelected = selectedCustomizations.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (_) => onToggle(option),
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppTheme.primaryColor : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
