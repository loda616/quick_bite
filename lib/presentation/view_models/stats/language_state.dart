import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LanguageState extends Equatable {
  final Locale locale;
  final String languageCode;
  final String countryCode;

  const LanguageState({
    this.locale = const Locale('en', 'US'),
    this.languageCode = 'en',
    this.countryCode = 'US',
  });

  LanguageState copyWith({
    Locale? locale,
    String? languageCode,
    String? countryCode,
  }) {
    return LanguageState(
      locale: locale ?? this.locale,
      languageCode: languageCode ?? this.languageCode,
      countryCode: countryCode ?? this.countryCode,
    );
  }

  /// Get language display name
  String get languageDisplayName {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      default:
        return 'English';
    }
  }

  /// Check if current language is RTL
  bool get isRTL => languageCode == 'ar';

  /// Get text direction for UI
  TextDirection get textDirection => isRTL ? TextDirection.rtl : TextDirection.ltr;

  @override
  List<Object?> get props => [locale, languageCode, countryCode];

  @override
  String toString() {
    return 'LanguageState(locale: $locale, languageCode: $languageCode, countryCode: $countryCode)';
  }
}