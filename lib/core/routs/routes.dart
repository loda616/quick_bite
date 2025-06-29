import 'package:flutter/material.dart';
import 'package:quick_bite/presentation/screens/home/home_screen.dart';
import 'package:quick_bite/presentation/screens/main_screen.dart';
import 'package:quick_bite/presentation/screens/auth/login_screen.dart';
import 'package:quick_bite/presentation/screens/auth/registration_screen.dart';
import 'package:quick_bite/presentation/screens/auth/forget_password_screen.dart';
import 'package:quick_bite/presentation/screens/auth/reset_link_sent_screen.dart';
import 'package:quick_bite/presentation/screens/cart/cart_screen.dart';
import 'package:quick_bite/presentation/screens/orders/orders_screen.dart';
import 'package:quick_bite/presentation/screens/settings/settings_screen.dart';
import 'package:quick_bite/presentation/screens/profile_screen.dart';
import 'package:quick_bite/presentation/screens/food/food_item_details_screen.dart';
import 'package:quick_bite/data/models/food_item.dart';

import '../../presentation/screens/food/favorites_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String main = '/main';
  static const String home = '/home';
  static const String auth = '/auth';
  static const String register = '/register';
  static const String forgetPassword = '/forget-password';
  static const String resetLinkSent = '/reset-link-sent';
  static const String food = '/food';
  static const String foodDetails = '/food-details';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String favorites = '/favorites';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeName = settings.name;

    if (routeName == initial) {
      return MaterialPageRoute(builder: (context) => const MainScreen());
    }

    if (routeName == main) {
      return MaterialPageRoute(builder: (context) => const MainScreen());
    }

    if (routeName == home) {
      return MaterialPageRoute(builder: (context) => const HomeScreen());
    }

    if (routeName == auth) {
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    }

    if (routeName == register) {
      return MaterialPageRoute(builder: (context) => const RegistrationScreen());
    }

    if (routeName == forgetPassword) {
      return MaterialPageRoute(builder: (context) => const ForgetPasswordScreen());
    }

    if (routeName == resetLinkSent) {
      return MaterialPageRoute(builder: (context) => const ResetLinkSentScreen());
    }

    if (routeName == cart) {
      return MaterialPageRoute(builder: (context) => const CartScreen());
    }

    if (routeName == orders) {
      return MaterialPageRoute(builder: (context) => const OrdersScreen());
    }

    if (routeName == settings) {
      return MaterialPageRoute(builder: (context) => const SettingsScreen());
    }

    if (routeName == profile) {
      return MaterialPageRoute(builder: (context) => const ProfileScreen());
    }

    if (routeName == favorites) {
      return MaterialPageRoute(builder: (context) => const FavoritesScreen());
    }

    if (routeName == foodDetails) {
      if (settings.arguments is FoodItem) {
        final foodItem = settings.arguments as FoodItem;
        return MaterialPageRoute(
          builder: (context) => FoodItemDetailsScreen(item: foodItem),
        );
      }
      return _errorRoute('Invalid arguments for food details');
    }

    // Default case - route not found
    return _errorRoute('No route defined for $routeName');
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Route Error',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.main,
                      (route) => false,
                ),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//// routes.dart - Alternative approach using if-else
// import 'package:flutter/material.dart';
// import 'package:quick_bite/presentation/screens/home/home_screen.dart';
// import 'package:quick_bite/presentation/screens/auth/login_screen.dart';
// import 'package:quick_bite/presentation/screens/auth/registration_screen.dart';
// import 'package:quick_bite/presentation/screens/auth/forget_password_screen.dart';
// import 'package:quick_bite/presentation/screens/auth/reset_link_sent_screen.dart';
// import 'package:quick_bite/presentation/screens/cart/cart_screen.dart';
// import 'package:quick_bite/presentation/screens/orders/orders_screen.dart';
// import 'package:quick_bite/presentation/screens/settings/settings_screen.dart';
// import 'package:quick_bite/presentation/screens/profile_screen.dart';
// import 'package:quick_bite/presentation/screens/food/food_item_details_screen.dart';
// import 'package:quick_bite/presentation/screens/favorites_screen.dart';
// import 'package:quick_bite/data/models/food_item.dart';
//
// class AppRoutes {
//   static const String initial = '/';
//   static const String home = '/home';
//   static const String auth = '/auth';
//   static const String register = '/register';
//   static const String forgetPassword = '/forget-password';
//   static const String resetLinkSent = '/reset-link-sent';
//   static const String food = '/food';
//   static const String foodDetails = '/food-details';
//   static const String cart = '/cart';
//   static const String orders = '/orders';
//   static const String settings = '/settings';
//   static const String profile = '/profile';
//   static const String favorites = '/favorites';
//
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     final routeName = settings.name;
//
//     if (routeName == initial || routeName == home) {
//       return MaterialPageRoute(builder: (context) => const HomeScreen());
//     }
//
//     if (routeName == auth) {
//       return MaterialPageRoute(builder: (context) => const LoginScreen());
//     }
//
//     if (routeName == register) {
//       return MaterialPageRoute(builder: (context) => const RegistrationScreen());
//     }
//
//     if (routeName == forgetPassword) {
//       return MaterialPageRoute(builder: (context) => const ForgetPasswordScreen());
//     }
//
//     if (routeName == resetLinkSent) {
//       return MaterialPageRoute(builder: (context) => const ResetLinkSentScreen());
//     }
//
//     if (routeName == cart) {
//       return MaterialPageRoute(builder: (context) => const CartScreen());
//     }
//
//     if (routeName == orders) {
//       return MaterialPageRoute(builder: (context) => const OrdersScreen());
//     }
//
//     if (routeName == settings) {
//       return MaterialPageRoute(builder: (context) => const SettingsScreen());
//     }
//
//     if (routeName == profile) {
//       return MaterialPageRoute(builder: (context) => const ProfileScreen());
//     }
//
//     if (routeName == favorites) {
//       return MaterialPageRoute(builder: (context) => const FavoritesScreen());
//     }
//
//     if (routeName == foodDetails) {
//       if (settings.arguments is FoodItem) {
//         final foodItem = settings.arguments as FoodItem;
//         return MaterialPageRoute(
//           builder: (context) => FoodItemDetailsScreen(item: foodItem),
//         );
//       }
//       return _errorRoute('Invalid arguments for food details');
//     }
//
//     // Default case - route not found
//     return _errorRoute('No route defined for $routeName');
//   }
//
//   static Route<dynamic> _errorRoute(String message) {
//     return MaterialPageRoute(
//       builder: (context) => Scaffold(
//         appBar: AppBar(title: const Text('Error')),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.error, size: 64, color: Colors.red),
//               const SizedBox(height: 16),
//               const Text(
//                 'Route Error',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 message,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 16),
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: () => Navigator.pushNamedAndRemoveUntil(
//                   context,
//                   AppRoutes.home,
//                   (route) => false,
//                 ),
//                 child: const Text('Go Home'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }