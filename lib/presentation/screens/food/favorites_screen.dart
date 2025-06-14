import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('favorites'),
      ),
      body: Center(
        child: Text('favorites_screen_coming_soon'),
      ),
    );
  }
}
