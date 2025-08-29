import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quick_bite/data/datasources/local/secure_storage_service.dart';
import 'package:quick_bite/data/datasources/remote/api_service.dart';
import 'package:quick_bite/data/datasources/remote/menu_api_service.dart';
import 'package:quick_bite/data/repository/auth_repository_impl.dart';
import 'package:quick_bite/data/repository/menu_repository_impl.dart';
import 'package:quick_bite/domin/repository/auth_repository.dart';
import 'package:quick_bite/domin/repository/menu_repository.dart';
import 'package:quick_bite/presentation/view_models/cubit/auth_cubit.dart';
import 'package:quick_bite/presentation/view_models/cubit/cart_cubit.dart';
import 'package:quick_bite/presentation/view_models/cubit/menu_cubit.dart';
import 'package:quick_bite/presentation/view_models/cubit/profile_cubit.dart';
import 'package:quick_bite/presentation/view_models/cubit/order_cubit.dart';
import 'package:quick_bite/presentation/view_models/cubit/language_cubit.dart';
import 'package:quick_bite/presentation/view_models/cubit/notification_cubit.dart';
import 'package:quick_bite/presentation/view_models/cubit/theme_cubit.dart';
import 'package:quick_bite/presentation/view_models/cubit/favorites_cubit.dart';
import 'package:quick_bite/data/datasources/remote/favorites_api_service.dart';
import 'package:quick_bite/data/repository/favorites_repository_impl.dart';
import 'package:quick_bite/domin/repository/favorites_repository.dart';
import 'package:quick_bite/presentation/view_models/stats/auth_stat.dart';
import 'package:quick_bite/presentation/view_models/stats/language_state.dart';
import 'package:quick_bite/presentation/screens/auth/login_screen.dart';
import 'package:quick_bite/presentation/screens/main_screen.dart';
import 'package:quick_bite/presentation/view_models/stats/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/dio_client.dart';
import 'core/routs/routes.dart';
import 'core/services/deep_link_service.dart';
import 'core/theme/app_theme.dart';
import 'l10n/generated/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(QuickBiteApp(prefs: prefs));
}

class QuickBiteApp extends StatefulWidget {
  final SharedPreferences prefs;

  const QuickBiteApp({super.key, required this.prefs});

  @override
  State<QuickBiteApp> createState() => _QuickBiteAppState();
}

class _QuickBiteAppState extends State<QuickBiteApp> {
  late final DeepLinkService _deepLinkService;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // Storage Service
        RepositoryProvider<SecureStorageService>(
          create: (context) => SecureStorageService(widget.prefs),
        ),

        // API Services
        RepositoryProvider<ApiService>(
          create: (context) => ApiService(DioClient.getDio()),
        ),
        RepositoryProvider<MenuApiService>(
          create: (context) => MenuApiService(DioClient.getDio()),
        ),

        // Repositories
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            context.read<ApiService>(),
            context.read<SecureStorageService>(),
          ),
        ),
        RepositoryProvider<MenuRepository>(
          create: (context) => MenuRepositoryImpl(
            context.read<MenuApiService>(),
          ),
        ),
        RepositoryProvider<FavoritesApiService>(
          create: (context) => FavoritesApiService(DioClient.getDio()),
        ),
        RepositoryProvider<FavoritesRepository>(
          create: (context) => FavoritesRepositoryImpl(
            context.read<FavoritesApiService>(),
            context.read<SecureStorageService>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // Theme Cubit - Initialize first for system theme detection
          BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit(widget.prefs),
          ),

          // Language Cubit
          BlocProvider<LanguageCubit>(
            create: (context) => LanguageCubit(widget.prefs),
          ),

          // Notification Cubit
          BlocProvider<NotificationCubit>(
            create: (context) => NotificationCubit(widget.prefs),
          ),

          // Auth Cubit
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(
              context.read<AuthRepository>(),
            )..quickCheckAuthStatus(),
          ),

          // Menu Cubit
          BlocProvider<MenuCubit>(
            create: (context) => MenuCubit(
              context.read<MenuRepository>(),
            ),
          ),

          // Profile Cubit
          BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(
              context.read<AuthRepository>(),
            ),
          ),

          // Cart Cubit
          BlocProvider<CartCubit>(
            create: (context) => CartCubit(),
          ),

          // Order Cubit
          BlocProvider<OrderCubit>(
            create: (context) => OrderCubit(),
          ),

          // Favorites Cubit
          BlocProvider<FavoritesCubit>(
            create: (context) => FavoritesCubit(
              context.read<FavoritesRepository>(),
            )..initializeFavorites(),
          ),
        ],
        child: Builder(
          builder: (context) {
            // Initialize DeepLinkService here where context is available
            _deepLinkService = DeepLinkService(
              menuRepository: context.read<MenuRepository>(),
              navigatorKey: navigatorKey,
            );
            _deepLinkService.init();

            return BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, themeState) {
                return BlocBuilder<LanguageCubit, LanguageState>(
                  builder: (context, languageState) {
                    return BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, authState) {
                        return MaterialApp(
                          title: 'QuickBite',
                          debugShowCheckedModeBanner: false,
                          navigatorKey: navigatorKey,

                          // Localization Configuration
                          localizationsDelegates: const [
                            AppLocalizations.delegate,
                            GlobalMaterialLocalizations.delegate,
                            GlobalWidgetsLocalizations.delegate,
                            GlobalCupertinoLocalizations.delegate,
                          ],
                          supportedLocales: const [
                            Locale('en', 'US'),
                            Locale('ar', 'SA'),
                          ],
                          locale: languageState.locale,

                          // Theme Configuration
                          theme: AppTheme.lightTheme,
                          darkTheme: AppTheme.darkTheme,
                          themeMode: themeState.flutterThemeMode,

                          // Route Configuration
                          onGenerateRoute: AppRoutes.generateRoute,
                          home: _getInitialScreen(context, authState),

                          // App Lifecycle Listener for System Theme Changes
                          builder: (context, child) {
                            return SystemThemeListener(
                              child: child!,
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          }
        ),
      ),
    );
  }

  Widget _getInitialScreen(BuildContext context, AuthState authState) {
    // Show loading only for comprehensive checks, not quick checks
    if (authState.isLoading && authState.userName == null) {
      return const SplashScreen();
    }

    // Navigate to MainScreen when authenticated, LoginScreen when not
    return authState.isAuthenticated ? const MainScreen() : const LoginScreen();
  }

  @override
  void dispose() {
    _deepLinkService.dispose();
    super.dispose();
  }
}

/// Widget to listen for system theme changes
class SystemThemeListener extends StatefulWidget {
  final Widget child;

  const SystemThemeListener({super.key, required this.child});

  @override
  State<SystemThemeListener> createState() => _SystemThemeListenerState();
}

class _SystemThemeListenerState extends State<SystemThemeListener> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    // Notify ThemeCubit of system brightness change
    if (mounted) {
      context.read<ThemeCubit>().onSystemBrightnessChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
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
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.restaurant,
                        size: 60,
                        color: isDark ? Colors.black : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // App Name
                    Text(
                      l10n.appTitle,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // App Tagline
                    Text(
                      l10n.appTagline,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Loading Indicator
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
