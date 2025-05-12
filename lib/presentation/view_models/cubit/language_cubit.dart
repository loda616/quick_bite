import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/view_models/stats/language_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<LanguageState> {
  static const String _languageKey = 'selected_language';
  final SharedPreferences prefs;

  LanguageCubit(this.prefs) : super(const LanguageState(locale: Locale('en'))) {
    _loadSavedLanguage();
  }

  void _loadSavedLanguage() {
    final String? languageCode = prefs.getString(_languageKey);
    if (languageCode != null) {
      emit(LanguageState(locale: Locale(languageCode)));
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    await prefs.setString(_languageKey, languageCode);
    emit(LanguageState(locale: Locale(languageCode)));
  }
}