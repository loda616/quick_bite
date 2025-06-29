import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
import 'package:quick_bite/presentation/view_models/cubit/auth_cubit.dart';
import 'package:quick_bite/presentation/view_models/cubit/language_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/language_state.dart';
import 'package:quick_bite/theme/app_theme.dart';

import '../../view_models/stats/auth_stat.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageCubit = context.read<LanguageCubit>();
  

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFFf8f1df),
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.accentColor),
        titleTextStyle: const TextStyle(
          color: AppTheme.accentColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body:
    BlocListener<AuthCubit, AuthState>(
    listener: (context, state) {
    if (!state.isAuthenticated) {
    Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => const LoginScreen()),
    (route) => false,
    );
    }
    },
    child:
       ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications, color: AppTheme.accentColor),
            title: const Text(    'notifications'),
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
                title: const Text(    'language'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.locale.languageCode == 'en'
                          ?     'english'
                          :     'arabic',
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
                      title: const Text(    'selectLanguage'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text(    'english'),
                            onTap: () {
                              languageCubit.changeLanguage('en');
                              Navigator.pop(context);
                            },
                          ),
    ListTile(
    leading: const Icon(Icons.logout, color: AppTheme.primaryColor),
    title: const Text(
    'Logout',
    style: TextStyle(color: AppTheme.primaryColor),
    ),
    onTap: () {
    context.read<AuthCubit>().logout();
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
            title: const Text(    'darkMode'),
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
            title: const Text(
                  'logout',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<AuthCubit>().logout();
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    )
    );
  }
}