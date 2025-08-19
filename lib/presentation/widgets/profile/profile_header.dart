import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String? subtitle;
  final String? imageUrl;

  const ProfileHeader({
    super.key,
    required this.name,
    this.subtitle,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile Picture
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
              child: imageUrl == null
                  ? const Icon(
                Icons.person,
                size: 60,
                color: AppTheme.primaryColor,
              )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    // TODO: Implement image picker
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Image picker coming soon!'),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // User Name
        Text(
          name,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.accentColor,
          ),
          textAlign: TextAlign.center,
        ),

        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],

        const SizedBox(height: 8),

        // Online Status Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Online',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
