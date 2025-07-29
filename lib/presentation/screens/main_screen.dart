import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/view_models/cubit/auth_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/auth_stat.dart';
import 'package:quick_bite/presentation/screens/auth/login_screen.dart';
import 'package:quick_bite/presentation/screens/home/home_screen.dart';
import 'package:quick_bite/presentation/screens/cart/cart_screen.dart';
import 'package:quick_bite/presentation/screens/orders/orders_screen.dart';
import 'package:quick_bite/presentation/screens/profile_screen.dart';
import 'package:quick_bite/presentation/screens/settings/settings_screen.dart';

import '../../l10n/generated/app_localizations.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CartScreen(),
    const OrdersScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<NavigationDestination> _destinations = [
      NavigationDestination(
        icon: const Icon(Icons.home_outlined),
        selectedIcon: const Icon(Icons.home),
        label: l10n.home,
      ),
      NavigationDestination(
        icon: const Icon(Icons.shopping_cart_outlined),
        selectedIcon: const Icon(Icons.shopping_cart),
        label: l10n.cart,
      ),
      NavigationDestination(
        icon: const Icon(Icons.receipt_long_outlined),
        selectedIcon: const Icon(Icons.receipt_long),
        label: l10n.orders,
      ),
      NavigationDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person),
        label: l10n.profile,
      ),
      NavigationDestination(
        icon: const Icon(Icons.settings_outlined),
        selectedIcon: const Icon(Icons.settings),
        label: l10n.settings,
      ),
    ];

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // Navigate to login if user is not authenticated
        if (!state.isAuthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
          );
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: _destinations,
            backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            indicatorColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            height: 65,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          ),
        ),
      ),
    );
  }
}