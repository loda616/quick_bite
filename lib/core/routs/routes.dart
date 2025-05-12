import 'package:flutter/material.dart';
import 'package:quick_bite/presentation/screens/home/home_screen.dart';
import 'package:quick_bite/presentation/screens/auth/login_screen.dart';
import 'package:quick_bite/presentation/screens/cart/cart_screen.dart';
import 'package:quick_bite/presentation/screens/orders/orders_screen.dart';
import 'package:quick_bite/presentation/screens/settings/settings_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';
  static const String auth = '/auth';
  static const String food = '/food';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case auth:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case orders:
        return MaterialPageRoute(builder: (_) => const OrdersScreen());
      case 'settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
