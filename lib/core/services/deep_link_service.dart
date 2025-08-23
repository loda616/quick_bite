import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:quick_bite/core/routs/routes.dart';
import 'package:quick_bite/domin/repository/menu_repository.dart';

class DeepLinkService {
  final MenuRepository menuRepository;
  final GlobalKey<NavigatorState> navigatorKey;

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  DeepLinkService({required this.menuRepository, required this.navigatorKey});

  Future<void> init() async {
    // Handle initial link
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleLink(initialUri);
    }

    // Handle subsequent links
    _sub = _appLinks.uriLinkStream.listen((Uri uri) {
      _handleLink(uri);
    }, onError: (err) {
      // Handle errors
      print('Error listening to app_links: $err');
    });
  }

  void _handleLink(Uri uri) {
    print('Handling link: $uri');
    if (uri.host == 'quickbite.dev' && uri.pathSegments.length == 2 && uri.pathSegments[0] == 'item') {
      final itemId = uri.pathSegments[1];
      _navigateToFoodDetails(itemId);
    } else if (uri.scheme == 'quickbite' && uri.host == 'item' && uri.pathSegments.isNotEmpty) {
      // This is for custom scheme quickbite://item/123
      // The host is 'item' and pathSegments[0] is the id
      final itemId = uri.pathSegments[0];
       _navigateToFoodDetails(itemId);
    }
  }

  Future<void> _navigateToFoodDetails(String itemId) async {
    try {
      final foodItem = await menuRepository.getItemById(itemId);

      if (foodItem != null) {
        navigatorKey.currentState?.pushNamed(
          AppRoutes.foodDetails,
          arguments: foodItem,
        );
      } else {
        throw Exception('Food item not found');
      }
    } catch (e) {
      print('Error navigating to food details: $e');
      // Optionally, show an error message to the user
    }
  }

  void dispose() {
    _sub?.cancel();
  }
}
