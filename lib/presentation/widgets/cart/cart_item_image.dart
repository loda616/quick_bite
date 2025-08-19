import 'package:flutter/material.dart';

class CartItemImage extends StatelessWidget {
  final String imageUrl;

  const CartItemImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        imageUrl,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 80,
            height: 80,
            color: Theme.of(context).colorScheme.surface,
            child: Icon(Icons.restaurant, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
          );
        },
      ),
    );
  }
}
