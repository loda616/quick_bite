import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/view_models/cubit/cart_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/cart_state.dart';
import '../../../../core/routs/routes.dart';
import '../../../l10n/generated/app_localizations.dart';

class CartDialogs {
  static void showClearCartDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearCart),
        content: Text(l10n.clearCartConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CartCubit>().clearCart();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Cart cleared successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.clearCart),
          ),
        ],
      ),
    );
  }

  static void showCheckoutDialog(BuildContext context, CartState state) {
    final deliveryFee = state.total > 25 ? 0.0 : 5.0;
    final totalWithDelivery = state.total + deliveryFee;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.checkout),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l10n.checkout} ${l10n.total}:'),
            const SizedBox(height: 8),
            Text('${l10n.cart}: ${state.itemCount}'),
            Text('${l10n.total}: \$${totalWithDelivery.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            Text('${l10n.checkout} functionality will be implemented soon!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.orders);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order placed successfully! (Demo)'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('Place Order'),
          ),
        ],
      ),
    );
  }
}