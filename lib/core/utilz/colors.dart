import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppColors {
  // Use AppTheme colors as single source of truth
  static const Color primary = AppTheme.primaryColor;
  static const Color secondary = AppTheme.accentColor;
  static const Color background = AppTheme.backgroundColor;
  static const Color darkBackground = AppTheme.darkBackgroundColor;
  static const Color white = Color(0xFFFFFFFF);
  static const Color text = AppTheme.accentColor;
  static const Color grey = Color(0xFF9E9E9E);
  static const Color error = AppTheme.errorColor;
  static const Color success = AppTheme.successColor;
  static const Color warning = AppTheme.warningColor;
  static const Color orange = AppTheme.primaryColor; // Remove duplicate orange definition
}
