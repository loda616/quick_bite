import 'package:flutter/material.dart';
import 'package:quick_bite/presentation/view_models/stats/cart_state.dart';
import '../../../../core/routs/routes.dart';

class CartDialogs {
  static void showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement clear cart functionality
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Clear cart feature coming soon!'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear Cart'),
          ),
        ],
      ),
    );
  }

  static void showCheckoutDialog(BuildContext context, CartState state) {
    final deliveryFee = state.total > 25 ? 0.0 : 5.0;
    final totalWithDelivery = state.total + deliveryFee;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Order Summary:'),
            const SizedBox(height: 8),
            Text('Items: ${state.itemCount}'),
            Text('Total: \$${totalWithDelivery.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text('Checkout functionality will be implemented soon!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.orders);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order placed successfully! (Demo)'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Place Order'),
          ),
        ],
      ),
    );
  }
}