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
                  backgroundColor: Theme.of(context).colorScheme.primary,
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

}
