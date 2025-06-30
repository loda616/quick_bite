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
            color: Colors.grey[300],
            child: const Icon(Icons.restaurant, color: Colors.grey),
          );
        },
      ),
    );
  }
}