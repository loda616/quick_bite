import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/data/datasources/local/secure_storage_service.dart';
import 'package:quick_bite/data/datasources/remote/api_service.dart';
import 'package:quick_bite/data/repository/auth_repository_impl.dart';
import 'package:quick_bite/domin/repository/auth_repository.dart';
import 'package:quick_bite/presentation/view_models/cubit/auth_cubit.dart';
import 'package:quick_bite/presentation/view_models/cubit/cart_cubit.dart';
import 'package:quick_bite/presentation/view_models/cubit/profile_cubit.dart';
import 'package:quick_bite/presentation/view_models/cubit/order_cubit.dart';
import 'package:quick_bite/presentation/view_models/cubit/language_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/auth_stat.dart';
import 'package:quick_bite/presentation/screens/auth/login_screen.dart';
import 'package:quick_bite/presentation/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/dio_client.dart';
import 'core/routs/routes.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(QuickBiteApp(prefs: prefs));
}

class QuickBiteApp extends StatelessWidget {
  final SharedPreferences prefs;

  const QuickBiteApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SecureStorageService>(
          create: (context) => SecureStorageService(),
        ),
        RepositoryProvider<ApiService>(
          create: (context) => ApiService(DioClient.getDio()),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            context.read<ApiService>(),
            context.read<SecureStorageService>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LanguageCubit>(
            create: (context) => LanguageCubit(prefs),
          ),
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(
              context.read<AuthRepository>(),
            )..checkAuthStatus(), // Check auth status on app start
          ),
          BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(
              context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<CartCubit>(
            create: (context) => CartCubit(),
          ),
          BlocProvider<OrderCubit>(
            create: (context) => OrderCubit(),
          ),
        ],
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            return MaterialApp(
              title: 'QuickBite',
              theme: AppTheme.lightTheme,
              onGenerateRoute: AppRoutes.generateRoute,
              home: _getInitialScreen(authState),
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }

  Widget _getInitialScreen(AuthState authState) {
    // Show loading while checking auth status
    if (authState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Navigate to MainScreen (with bottom nav) when authenticated, LoginScreen when not
    return authState.isAuthenticated ? const MainScreen() : const LoginScreen();
  }
}