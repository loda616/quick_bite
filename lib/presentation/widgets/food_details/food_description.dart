import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class FoodDescription extends StatelessWidget {
  final String description;

  const FoodDescription({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.accentColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: AppTheme.accentColor,
            ),
          ),
        ),
      ],
    );
  }
}