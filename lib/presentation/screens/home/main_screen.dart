import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../core/app_theme.dart';
import '../food/favorites_screen.dart';
import '../orders/orders_screen.dart';
import '../settings/settings_screen.dart';
import 'home_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    FavoritesScreen(),
    OrdersScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'home' ,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: 'favorites' ,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: 'orders' ,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: 'settings' ,
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: const Color(0xFFf8f1df),
        selectedItemColor: AppTheme.darkTheme.secondaryHeaderColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
