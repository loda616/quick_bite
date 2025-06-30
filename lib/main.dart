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
          create: (context) => SecureStorageService(prefs),
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
            )..quickCheckAuthStatus(), // Fast startup check!
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
              home: _getInitialScreen(context, authState),
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }

  Widget _getInitialScreen(BuildContext context, AuthState authState) {
    // Show loading only for comprehensive checks, not quick checks
    if (authState.isLoading && authState.userName == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFf8f1df),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Fixed Image widget - using Image.asset with proper errorBuilder
              Image.asset(
                'assets/images/QuickBite-logo.png',
                height: 120,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.restaurant,
                    size: 64,
                    color: Color(0xFF2E2E2E),
                  );
                },
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(
                color: Color(0xFFFF6B00),
              ),
              const SizedBox(height: 16),
              const Text(
                'Loading QuickBite...',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2E2E2E),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Navigate to MainScreen when authenticated, LoginScreen when not
    return authState.isAuthenticated ? const MainScreen() : const LoginScreen();
  }
}

/// Enhanced SplashScreen widget for better UX during loading
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8f1df),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Fixed Image widget - using Image.asset with proper errorBuilder
              Image.asset(
                'assets/images/QuickBite-logo.png',
                height: 150,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.restaurant,
                    size: 100,
                    color: Color(0xFFFF6B00),
                  );
                },
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(
                color: Color(0xFFFF6B00),
                strokeWidth: 3,
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome to QuickBite',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E2E2E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Fast food, faster delivery',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}