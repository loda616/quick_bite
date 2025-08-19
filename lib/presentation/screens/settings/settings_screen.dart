import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/view_models/cubit/language_cubit.dart';
import 'package:quick_bite/presentation/view_models/cubit/theme_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/language_state.dart';
import 'package:quick_bite/presentation/view_models/stats/theme_state.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/common/standard_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: StandardAppBar(
        title: l10n.settings,
      ),
      body: ListView(
        children: [
          // Account Section
          _buildSectionHeader(context, l10n.account),

          // Notifications Toggle
          ListTile(
            leading: Icon(
              Icons.notifications_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(l10n.notifications),
            subtitle: Text(l10n.receiveNotifications),
            trailing: Switch(
              value: true, // TODO: Implement notification state management
              onChanged: (value) {
                // TODO: Implement notifications toggle
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.helpSupport + ' coming soon!'),
                  ),
                );
              },
            ),
          ),

          const Divider(),

          // Appearance Section
          _buildSectionHeader(context, l10n.appearance),

          // Language Selection
          BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, languageState) {
              return ListTile(
                leading: Icon(
                  Icons.language_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(l10n.language),
                subtitle: Text(
                  languageState.locale.languageCode == 'en' ? l10n.english : l10n.arabic,
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showLanguageDialog(context),
              );
            },
          ),

          // Theme Selection (Dropdown Only - No Toggle Switch)
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return ListTile(
                leading: Icon(
                  themeState.themeIcon,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(l10n.theme),
                subtitle: Text('${l10n.theme}: ${_getThemeDisplayName(context, themeState.themeMode)}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showThemeDialog(context),
              );
            },
          ),

          const Divider(),

          // App Info Section
          _buildSectionHeader(context, l10n.about),

          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(l10n.about),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
          ),

          ListTile(
            leading: Icon(
              Icons.help_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(l10n.helpSupport),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.helpSupport + ' coming soon!'),
                ),
              );
            },
          ),

          ListTile(
            leading: Icon(
              Icons.privacy_tip_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(l10n.privacyPolicy),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, '/privacy-policy');
            },
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  String _getThemeDisplayName(BuildContext context, AppThemeMode themeMode) {
    final l10n = AppLocalizations.of(context)!;
    switch (themeMode) {
      case AppThemeMode.light:
        return l10n.light;
      case AppThemeMode.dark:
        return l10n.dark;
      case AppThemeMode.system:
        return l10n.system;
    }
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, languageState) {
          return AlertDialog(
            title: Text(l10n.selectLanguage),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLanguageOption(
                  context: context,
                  title: l10n.english,
                  value: 'en',
                  currentValue: languageState.locale.languageCode,
                  onTap: () {
                    context.read<LanguageCubit>().changeLanguage('en');
                    Navigator.pop(context);
                  },
                ),
                _buildLanguageOption(
                  context: context,
                  title: l10n.arabic,
                  value: 'ar',
                  currentValue: languageState.locale.languageCode,
                  onTap: () {
                    context.read<LanguageCubit>().changeLanguage('ar');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancel),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String title,
    required String value,
    required String currentValue,
    required VoidCallback onTap,
  }) {
    final isSelected = value == currentValue;
    return ListTile(
      title: Text(title),
      leading: Radio<String>(
        value: value,
        groupValue: currentValue,
        onChanged: (_) => onTap(),
      ),
      onTap: onTap,
      trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
    );
  }

  void _showThemeDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return AlertDialog(
            title: Text(l10n.selectTheme),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildThemeOption(
                  context: context,
                  title: l10n.light,
                  subtitle: l10n.alwaysLight,
                  icon: Icons.light_mode,
                  value: AppThemeMode.light,
                  currentValue: themeState.themeMode,
                  onTap: () {
                    context.read<ThemeCubit>().setLightTheme();
                    Navigator.pop(context);
                  },
                ),
                _buildThemeOption(
                  context: context,
                  title: l10n.dark,
                  subtitle: l10n.alwaysDark,
                  icon: Icons.dark_mode,
                  value: AppThemeMode.dark,
                  currentValue: themeState.themeMode,
                  onTap: () {
                    context.read<ThemeCubit>().setDarkTheme();
                    Navigator.pop(context);
                  },
                ),
                _buildThemeOption(
                  context: context,
                  title: l10n.system,
                  subtitle: l10n.followSystem,
                  icon: Icons.settings_brightness,
                  value: AppThemeMode.system,
                  currentValue: themeState.themeMode,
                  onTap: () {
                    context.read<ThemeCubit>().setSystemTheme();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancel),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required AppThemeMode value,
    required AppThemeMode currentValue,
    required VoidCallback onTap,
  }) {
    final isSelected = value == currentValue;
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: onTap,
    );
  }

}
