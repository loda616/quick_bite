import 'package:flutter/material.dart';
 
import 'package:quick_bite/theme/app_theme.dart';

class ProfileInfoCard extends StatelessWidget {
  final String title;
  final Map<String, String> items;
  final VoidCallback? onEditPressed;

  const ProfileInfoCard({
    super.key,
    required this.title,
    required this.items,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
  

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                if (onEditPressed != null)
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: onEditPressed,
                    color: AppTheme.accentColor,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            ...items.entries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}