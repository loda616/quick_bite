import 'package:flutter/material.dart';
import 'package:quick_bite/data/models/food_item.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';

class FoodHeaderInfo extends StatelessWidget {
  final FoodItem item;

  const FoodHeaderInfo({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Item Name and Price
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface, // Theme-aware color
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.category,
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '\$${item.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.black : Colors.white, // Theme-aware color
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Rating and Reviews
        if (item.rating != null)
          Row(
            children: [
              Icon(
                Icons.star,
                size: 24,
                color: Colors.amber[700],
              ),
              const SizedBox(width: 4),
              Text(
                item.rating!.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface, // Theme-aware color
                ),
              ),
              if (item.reviewCount != null)
                Text(
                  ' (${item.reviewCount} reviews)',
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.6), // Theme-aware color
                  ),
                ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: item.isAvailable
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: item.isAvailable
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              child: Text(
                item.isAvailable ? l10n.available : l10n.notAvailable,
                style: TextStyle(
                  color: item.isAvailable
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

