import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/screens/home/main_screen.dart';
import 'package:quick_bite/presentation/view_models/cubit/language_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/auth_stat.dart';
import 'package:quick_bite/presentation/view_models/stats/language_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme/app_theme.dart';

import 'presentation/screens/auth/login_screen.dart';
import 'presentation/view_models/cubit/auth_cubit.dart';
import 'presentation/view_models/cubit/profile_cubit.dart';
import 'presentation/view_models/cubit/cart_cubit.dart';
import 'presentation/view_models/cubit/menu_cubit.dart';
import 'presentation/view_models/cubit/order_cubit.dart';
import 'data/datasources/remote/api_service.dart';
import 'core/network/dio_client.dart';
import 'data/repository/menu_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => OrderCubit()),
        BlocProvider(
          create: (context) => MenuCubit(
            MenuRepository(ApiService(DioClient().dio)),
          )..loadCategoriesAndItems(),
        ),
        BlocProvider(create: (context) => LanguageCubit(prefs)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return MaterialApp(
          locale: state.locale,
          title: 'QuickBite',
          theme: AppTheme.lightTheme,
          home: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              return authState.isAuthenticated
                  ? const MainScreen()
                  : const LoginScreen();
            },
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

//class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});
//
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _screens = [
//     const HomeScreen(),
//     const FavoritesScreen(),
//     const OrdersScreen(),
//     const SettingsScreen(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             label: 'Favorites',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.history),
//             label: 'Orders',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         backgroundColor: const Color(0xFFf8f1df),
//         selectedItemColor: AppTheme.primaryColor,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//         type: BottomNavigationBarType.fixed,
//       ),
//     );
//   }
// }
