import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/view_models/stats/language_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<LanguageState> {
  static const String _languageKey = 'selected_language';
  final SharedPreferences prefs;

  LanguageCubit(this.prefs)
      : super(LanguageState(locale: _getLocale(prefs.getString(_languageKey)))) {
    _init();
  }

  static Locale _getLocale(String? code) {
    return code != null ? Locale(code) : const Locale('en');
  }

  Future<void> _init() async {
    final locale = _getLocale(prefs.getString(_languageKey));
    emit(LanguageState(locale: locale));
  }

  Future<void> changeLanguage(String code, BuildContext context) async {
    final newLocale = Locale(code);
    await prefs.setString(_languageKey, code);

    emit(LanguageState(locale: newLocale));
  }
}