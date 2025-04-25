import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../theme/app_theme.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const FoodItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.restaurant),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber[700]),
                      Text(
                        ' ${item.rating.toStringAsFixed(1)} (${item.reviewCount})',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  if (onAddToCart != null) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: item.isAvailable ? onAddToCart : null,
                        child: Text(
                          item.isAvailable ? 'Add to Cart' : 'Not Available',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
