import 'package:flutter/material.dart';
import '../../widgets/common/standard_app_bar.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StandardAppBar(
        title: 'Favorites',
      ),
      body: const Center(
        child: Text('Favorites Screen - Coming Soon'),
      ),
    );
  }
}
