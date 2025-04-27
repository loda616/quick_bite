import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: Colors.white,
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
            leading:
                const Icon(Icons.notifications, color: AppTheme.accentColor),
            title: Text(l10n.notifications),
            trailing: Switch(
              value: true, // TODO: Implement notifications state
              onChanged: (value) {
                // TODO: Implement notifications toggle
              },
              activeColor: AppTheme.primaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language, color: AppTheme.accentColor),
            title: Text(l10n.language),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  languageProvider.currentLocale.languageCode == 'en'
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
                          languageProvider.changeLanguage('en');
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text(l10n.arabic),
                        onTap: () {
                          languageProvider.changeLanguage('ar');
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
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
              authProvider.logout(context);
              // TODO: Navigate to login screen
            },
          ),
        ],
      ),
    );
  }
}
