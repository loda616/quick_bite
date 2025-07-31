import 'package:flutter/material.dart';
import 'package:quick_bite/data/models/food_item.dart';
import '../../../../core/routs/routes.dart';
import '../../../l10n/generated/app_localizations.dart' show AppLocalizations;

class FoodDetailsBottomBar extends StatelessWidget {
  final FoodItem item;
  final int quantity;
  final VoidCallback onAddToCart;

  const FoodDetailsBottomBar({
    super.key,
    required this.item,
    required this.quantity,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final totalPrice = item.price * quantity;
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface, // Theme-aware background
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.3), // Theme-aware shadow
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total Price Display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${l10n.total}:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface, // Theme-aware color
                  ),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                // Add to Cart Button
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: item.isAvailable ? onAddToCart : null,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: Text(
                      item.isAvailable ? l10n.addToCart : l10n.notAvailable,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: item.isAvailable
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withOpacity(0.3),
                      foregroundColor: item.isAvailable
                          ? (isDarkMode ? Colors.black : Colors.white) // Theme-aware color
                          : theme.colorScheme.onSurface.withOpacity(0.6),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // View Cart Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.cart);
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: Text(l10n.cart),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                      side: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}