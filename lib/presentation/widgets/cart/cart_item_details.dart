import 'package:flutter/material.dart';
import 'package:quick_bite/presentation/view_models/stats/cart_state.dart';

import '../../../core/theme/app_theme.dart';

class CartItemDetails extends StatelessWidget {
  final CartItem item;

  const CartItemDetails({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.item.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.accentColor,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          item.item.category,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              '\$${item.item.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                decoration: item.quantity > 1 ? TextDecoration.lineThrough : null,
              ),
            ),
            if (item.quantity > 1) ...[
              const SizedBox(width: 8),
              Text(
                '\$${item.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ],
        ),
        if (item.customizations.isNotEmpty) ...[
          const SizedBox(height: 4),
          Wrap(
            children: item.customizations.map((customization) {
              return Container(
                margin: const EdgeInsets.only(right: 6, top: 2),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  customization,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}