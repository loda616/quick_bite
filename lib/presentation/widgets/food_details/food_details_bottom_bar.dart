import 'package:flutter/material.dart';
import 'package:quick_bite/data/models/food_item.dart';
import '../../../../core/routs/routes.dart';
import '../../../core/theme/app_theme.dart';

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

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
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
                  'Total:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.accentColor,
                  ),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
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
                      item.isAvailable ? 'Add to Cart' : 'Not Available',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: item.isAvailable
                          ? AppTheme.primaryColor
                          : Colors.grey,
                      foregroundColor: Colors.white,
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
                    label: const Text('Cart'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: const BorderSide(color: AppTheme.primaryColor, width: 2),
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