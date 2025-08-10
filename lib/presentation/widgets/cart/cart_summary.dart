import 'package:flutter/material.dart';
import 'package:quick_bite/presentation/view_models/stats/cart_state.dart';
import '../../../../core/routs/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8), // Reduced padding
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
              l10n.subtotal(state.itemCount),
              '${state.total.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 6), // Reduced spacing
            _buildSummaryRow(
              l10n.deliveryFee,
              deliveryFee == 0 ? l10n.free : '${deliveryFee.toStringAsFixed(2)}',
              valueColor: deliveryFee == 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
            ),
            const Divider(height: 16), // Reduced height
            _buildSummaryRow(
              l10n.total,
              '${totalWithDelivery.toStringAsFixed(2)}',
              titleStyle: const TextStyle(
                fontSize: 18, // Reduced font size
                fontWeight: FontWeight.bold,
                color: AppTheme.accentColor,
              ),
              valueStyle: const TextStyle(
                fontSize: 20, // Reduced font size
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),

            if (state.total <= 25) ...[
              const SizedBox(height: 6), // Reduced spacing
              Text(
                l10n.addMoreForFreeDelivery('${(25 - state.total).toStringAsFixed(2)}'),
                style: TextStyle(
                  fontSize: 12, // Reduced font size
                  color: Colors.orange[700],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            const SizedBox(height: 12), // Reduced spacing

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
                    icon: const Icon(Icons.add_shopping_cart, size: 18), // Reduced icon size
                    label: Text(
                      l10n.addMore,
                      style: const TextStyle(fontSize: 14), // Reduced font size
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: const BorderSide(color: AppTheme.primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 12), // Reduced padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.checkout);
                    },
                    icon: const Icon(Icons.payment, size: 18), // Reduced icon size
                    label: Text(
                      l10n.checkout,
                      style: const TextStyle(fontSize: 14), // Reduced font size
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12), // Reduced padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4), // Small bottom spacing
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
        Flexible( // Added Flexible to prevent overflow
          child: Text(
            title,
            style: titleStyle ??
                const TextStyle(
                  fontSize: 14, // Reduced font size
                  color: AppTheme.accentColor,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value,
          style: valueStyle ??
              TextStyle(
                fontSize: 14, // Reduced font size
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppTheme.accentColor,
              ),
        ),
      ],
    );
  }
}
