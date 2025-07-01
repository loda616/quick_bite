import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/view_models/cubit/language_cubit.dart';
import 'package:quick_bite/presentation/view_models/cubit/theme_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/language_state.dart';
import 'package:quick_bite/presentation/view_models/stats/theme_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Account Section
          _buildSectionHeader(context, 'Account'),

          // Notifications Toggle
          ListTile(
            leading: Icon(
              Icons.notifications_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Notifications'),
            subtitle: const Text('Receive push notifications'),
            trailing: Switch(
              value: true, // TODO: Implement notification state management
              onChanged: (value) {
                // TODO: Implement notifications toggle
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notification settings coming soon!'),
                  ),
                );
              },
            ),
          ),

          const Divider(),

          // Appearance Section
          _buildSectionHeader(context, 'Appearance'),

          // Language Selection
          BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, languageState) {
              return ListTile(
                leading: Icon(
                  Icons.language_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text('Language'),
                subtitle: Text(
                  languageState.locale.languageCode == 'en' ? 'English' : 'Arabic',
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
                title: const Text('Theme'),
                subtitle: Text('Current: ${themeState.themeDescription}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showThemeDialog(context),
              );
            },
          ),

          const Divider(),

          // App Info Section
          _buildSectionHeader(context, 'About'),

          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('App Version'),
            subtitle: const Text('1.0.0'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showAboutDialog(context);
            },
          ),

          ListTile(
            leading: Icon(
              Icons.help_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Help & Support coming soon!'),
                ),
              );
            },
          ),

          ListTile(
            leading: Icon(
              Icons.privacy_tip_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Privacy Policy coming soon!'),
                ),
              );
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

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, languageState) {
          return AlertDialog(
            title: const Text('Select Language'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLanguageOption(
                  context: context,
                  title: 'English',
                  value: 'en',
                  currentValue: languageState.locale.languageCode,
                  onTap: () {
                    context.read<LanguageCubit>().changeLanguage('en');
                    Navigator.pop(context);
                  },
                ),
                _buildLanguageOption(
                  context: context,
                  title: 'العربية',
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
                child: const Text('Cancel'),
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
      trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return AlertDialog(
            title: const Text('Select Theme'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildThemeOption(
                  context: context,
                  title: 'Light',
                  subtitle: 'Always use light theme',
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
                  title: 'Dark',
                  subtitle: 'Always use dark theme',
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
                  title: 'System',
                  subtitle: 'Follow system settings',
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
                child: const Text('Cancel'),
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

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'QuickBite',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.restaurant,
        size: 48,
        color: Color(0xFFFF6B00),
      ),
      children: [
        const Text('Fast food, faster delivery'),
        const SizedBox(height: 16),
        const Text('Built with Flutter and love ❤️'),
      ],
    );
  }
}