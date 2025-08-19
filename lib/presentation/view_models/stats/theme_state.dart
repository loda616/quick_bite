import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum AppThemeMode {
  light,
  dark,
  system,
}

class ThemeState extends Equatable {
  final AppThemeMode themeMode;
  final bool isDarkMode;
  final bool isSystemMode;

  const ThemeState({
    this.themeMode = AppThemeMode.light,
    this.isDarkMode = false,
    this.isSystemMode = false,
  });

  ThemeState copyWith({
    AppThemeMode? themeMode,
    bool? isDarkMode,
    bool? isSystemMode,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isSystemMode: isSystemMode ?? this.isSystemMode,
    );
  }

  /// Get Flutter ThemeMode from our AppThemeMode
  ThemeMode get flutterThemeMode {
    switch (themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  /// Get theme description for UI
  String get themeDescription {
    switch (themeMode) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }

  /// Get theme icon for UI
  IconData get themeIcon {
    switch (themeMode) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.settings_brightness;
    }
  }

  @override
  List<Object?> get props => [themeMode, isDarkMode, isSystemMode];

  @override
  String toString() {
    return 'ThemeState(themeMode: $themeMode, isDarkMode: $isDarkMode, isSystemMode: $isSystemMode)';
  }
}