import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../stats/language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  static const String _languageKey = 'app_language';
  final SharedPreferences _prefs;

  LanguageCubit(this._prefs) : super(const LanguageState()) {
    _loadLanguage();
  }

  /// Load language from SharedPreferences
  void _loadLanguage() {
    try {
      final savedLanguage = _prefs.getString(_languageKey) ?? 'en';
      _setLanguage(savedLanguage);
    } catch (e) {
      print('Error loading language: $e');
      // Fall back to English
      _setLanguage('en');
    }
  }

  /// Save language to SharedPreferences
  Future<void> _saveLanguage(String languageCode) async {
    try {
      await _prefs.setString(_languageKey, languageCode);
    } catch (e) {
      print('Error saving language: $e');
    }
  }

  /// Set language without saving (used internally)
  void _setLanguage(String languageCode) {
    Locale locale;
    String countryCode;

    switch (languageCode) {
      case 'ar':
        locale = const Locale('ar', 'SA');
        countryCode = 'SA';
        break;
      case 'en':
      default:
        locale = const Locale('en', 'US');
        countryCode = 'US';
        languageCode = 'en'; // Ensure fallback
        break;
    }

    emit(LanguageState(
      locale: locale,
      languageCode: languageCode,
      countryCode: countryCode,
    ));
  }

  /// Change language and save to preferences
  Future<void> changeLanguage(String languageCode) async {
    if (languageCode == state.languageCode) return;

    _setLanguage(languageCode);
    await _saveLanguage(languageCode);

    print('Language changed to: $languageCode');
  }

  /// Set English language
  Future<void> setEnglish() async {
    await changeLanguage('en');
  }

  /// Set Arabic language
  Future<void> setArabic() async {
    await changeLanguage('ar');
  }

  /// Toggle between English and Arabic
  Future<void> toggleLanguage() async {
    final newLanguage = state.languageCode == 'en' ? 'ar' : 'en';
    await changeLanguage(newLanguage);
  }

  /// Get supported locales for MaterialApp
  static List<Locale> get supportedLocales => [
    const Locale('en', 'US'),
    const Locale('ar', 'SA'),
  ];

  /// Get current language code
  String get currentLanguageCode => state.languageCode;

  /// Check if current language is Arabic
  bool get isArabic => state.languageCode == 'ar';

  /// Check if current language is English
  bool get isEnglish => state.languageCode == 'en';

  /// Check if current language is RTL
  bool get isRTL => state.isRTL;

  /// Get text direction
  TextDirection get textDirection => state.textDirection;
}