import 'package:flutter/material.dart';
import 'package:quick_bite/presentation/view_models/stats/cart_state.dart';
import '../../../../core/routs/routes.dart';
import '../../../core/theme/app_theme.dart';
import 'cart_dialogs.dart';

class CartSummary extends StatelessWidget {
  final CartState state;

  const CartSummary({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final deliveryFee = state.total > 25 ? 0.0 : 5.0;
    final totalWithDelivery = state.total + deliveryFee;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
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
            // Order Summary
            _buildSummaryRow(
              'Subtotal (${state.itemCount} items)',
              '\$${state.total.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Delivery Fee',
              deliveryFee == 0 ? 'FREE' : '\$${deliveryFee.toStringAsFixed(2)}',
              valueColor: deliveryFee == 0 ? Colors.green : AppTheme.accentColor,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              'Total',
              '\$${totalWithDelivery.toStringAsFixed(2)}',
              titleStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.accentColor,
              ),
              valueStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),

            if (state.total <= 25) ...[
              const SizedBox(height: 8),
              Text(
                'Add \$${(25 - state.total).toStringAsFixed(2)} more for free delivery!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.orange[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                            (route) => false,
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Add More'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: const BorderSide(color: AppTheme.primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      CartDialogs.showCheckoutDialog(context, state);
                    },
                    icon: const Icon(Icons.payment),
                    label: const Text('Checkout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
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

  Widget _buildSummaryRow(
      String title,
      String value, {
        TextStyle? titleStyle,
        TextStyle? valueStyle,
        Color? valueColor,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: titleStyle ??
              const TextStyle(
                fontSize: 16,
                color: AppTheme.accentColor,
              ),
        ),
        Text(
          value,
          style: valueStyle ??
              TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppTheme.accentColor,
              ),
        ),
      ],
    );
  }
}