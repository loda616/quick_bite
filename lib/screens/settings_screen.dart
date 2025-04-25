import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: Switch(
              value: true, // TODO: Implement notifications state
              onChanged: (value) {
                // TODO: Implement notifications toggle
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Implement language selection
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: false, // TODO: Implement theme state
              onChanged: (value) {
                // TODO: Implement theme toggle
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              authProvider.logout();
              // TODO: Navigate to login screen
            },
          ),
        ],
      ),
    );
  }
}
