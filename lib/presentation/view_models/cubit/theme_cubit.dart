import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../stats/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'app_theme_mode';
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(const ThemeState()) {
    _loadTheme();
  }

  /// Load theme from SharedPreferences
  void _loadTheme() {
    try {
      final savedTheme = _prefs.getString(_themeKey);
      AppThemeMode themeMode;

      switch (savedTheme) {
        case 'dark':
          themeMode = AppThemeMode.dark;
          break;
        case 'system':
          themeMode = AppThemeMode.system;
          break;
        case 'light':
        default:
          themeMode = AppThemeMode.light;
          break;
      }

      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      final isDarkMode = _calculateIsDarkMode(themeMode, brightness);
      final isSystemMode = themeMode == AppThemeMode.system;

      emit(ThemeState(
        themeMode: themeMode,
        isDarkMode: isDarkMode,
        isSystemMode: isSystemMode,
      ));

      _updateSystemUI(isDarkMode);
    } catch (e) {
      print('Error loading theme: $e');
      // Fall back to light theme
      emit(const ThemeState());
    }
  }

  /// Save theme to SharedPreferences
  Future<void> _saveTheme(AppThemeMode themeMode) async {
    try {
      String themeString;
      switch (themeMode) {
        case AppThemeMode.light:
          themeString = 'light';
          break;
        case AppThemeMode.dark:
          themeString = 'dark';
          break;
        case AppThemeMode.system:
          themeString = 'system';
          break;
      }
      await _prefs.setString(_themeKey, themeString);
    } catch (e) {
      print('Error saving theme: $e');
    }
  }

  /// Calculate if dark mode should be active
  bool _calculateIsDarkMode(AppThemeMode themeMode, Brightness systemBrightness) {
    switch (themeMode) {
      case AppThemeMode.light:
        return false;
      case AppThemeMode.dark:
        return true;
      case AppThemeMode.system:
        return systemBrightness == Brightness.dark;
    }
  }

  /// Update system UI (status bar, navigation bar) colors
  void _updateSystemUI(bool isDarkMode) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: isDarkMode ? AppTheme.darkBackgroundColor : AppTheme.backgroundColor,
        systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      ),
    );
  }

  /// Change theme mode
  Future<void> changeTheme(AppThemeMode themeMode) async {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final isDarkMode = _calculateIsDarkMode(themeMode, brightness);
    final isSystemMode = themeMode == AppThemeMode.system;

    emit(ThemeState(
      themeMode: themeMode,
      isDarkMode: isDarkMode,
      isSystemMode: isSystemMode,
    ));

    _updateSystemUI(isDarkMode);
    await _saveTheme(themeMode);
  }

  /// Toggle between light and dark (not system)
  Future<void> toggleTheme() async {
    final newTheme = state.themeMode == AppThemeMode.light
        ? AppThemeMode.dark
        : AppThemeMode.light;
    await changeTheme(newTheme);
  }

  /// Set light theme
  Future<void> setLightTheme() async {
    await changeTheme(AppThemeMode.light);
  }

  /// Set dark theme
  Future<void> setDarkTheme() async {
    await changeTheme(AppThemeMode.dark);
  }

  /// Set system theme
  Future<void> setSystemTheme() async {
    await changeTheme(AppThemeMode.system);
  }

  /// Handle system brightness changes (for system theme mode)
  void onSystemBrightnessChanged() {
    if (state.themeMode == AppThemeMode.system) {
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      final isDarkMode = brightness == Brightness.dark;

      if (isDarkMode != state.isDarkMode) {
        emit(state.copyWith(isDarkMode: isDarkMode));
        _updateSystemUI(isDarkMode);
      }
    }
  }

  /// Get current theme mode for UI display
  String get currentThemeDescription => state.themeDescription;

  /// Check if dark mode is currently active
  bool get isDarkMode => state.isDarkMode;

  /// Check if system theme is being used
  bool get isSystemMode => state.isSystemMode;
}
