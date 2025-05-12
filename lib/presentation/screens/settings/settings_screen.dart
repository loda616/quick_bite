import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quick_bite/presentation/view_models/cubit/auth_cubit.dart';
import 'package:quick_bite/presentation/view_models/cubit/language_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/language_state.dart';
import 'package:quick_bite/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final languageCubit = context.read<LanguageCubit>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: const Color(0xFFf8f1df),
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.accentColor),
        titleTextStyle: const TextStyle(
          color: AppTheme.accentColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications, color: AppTheme.accentColor),
            title: Text(l10n.notifications),
            trailing: Switch(
              value: true, // TODO: Implement notifications state
              onChanged: (value) {
                // TODO: Implement notifications toggle
              },
              activeColor: AppTheme.primaryColor,
            ),
          ),
          BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, state) {
              return ListTile(
                leading: const Icon(Icons.language, color: AppTheme.accentColor),
                title: Text(l10n.language),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.locale.languageCode == 'en'
                          ? l10n.english
                          : l10n.arabic,
                      style: const TextStyle(color: AppTheme.accentColor),
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        color: AppTheme.accentColor),
                  ],
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(l10n.selectLanguage),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text(l10n.english),
                            onTap: () {
                              languageCubit.changeLanguage('en');
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: Text(l10n.arabic),
                            onTap: () {
                              languageCubit.changeLanguage('ar');
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode, color: AppTheme.accentColor),
            title: Text(l10n.darkMode),
            trailing: Switch(
              value: false, // TODO: Implement theme state
              onChanged: (value) {
                // TODO: Implement theme toggle
              },
              activeColor: AppTheme.primaryColor,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppTheme.primaryColor),
            title: Text(
              l10n.logout,
              style: const TextStyle(color: AppTheme.primaryColor),
            ),
            onTap: () {
              authCubit.logout(context);
              // TODO: Navigate to login screen
            },
          ),
        ],
      ),
    );
  }
}