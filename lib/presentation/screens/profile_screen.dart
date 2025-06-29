import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/view_models/cubit/profile_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/profile_state.dart';
import 'package:quick_bite/presentation/widgets/profile/profile_header.dart';
import 'package:quick_bite/presentation/widgets/profile/profile_info_card.dart';
import 'package:quick_bite/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh profile data when screen opens
    context.read<ProfileCubit>().refreshProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFFf8f1df),
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.accentColor),
        titleTextStyle: const TextStyle(
          color: AppTheme.accentColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProfileCubit>().refreshProfile();
            },
            tooltip: 'Refresh Profile',
          ),
        ],
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<ProfileCubit>().refreshProfile();
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.name == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppTheme.primaryColor),
                  SizedBox(height: 16),
                  Text('Loading profile...'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<ProfileCubit>().refreshProfile();
            },
            color: AppTheme.primaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profile Header
                  ProfileHeader(
                    name: state.name ?? 'Guest User',
                    subtitle: state.role ?? 'User',
                  ),
                  const SizedBox(height: 24),

                  // Account Information Card
                  ProfileInfoCard(
                    title: 'Account Information',
                    icon: Icons.person,
                    items: {
                      'User ID': state.userId ?? 'N/A',
                      'Full Name': state.name ?? 'N/A',
                      'Email': state.email ?? 'N/A',
                      'Role': state.role ?? 'User',
                    },
                    onEditPressed: () => _showEditProfileDialog(context),
                  ),
                  const SizedBox(height: 16),

                  // Contact Information Card
                  ProfileInfoCard(
                    title: 'Contact Information',
                    icon: Icons.contact_phone,
                    items: {
                      'Phone': state.phone ?? 'Not provided',
                      'Address': state.address ?? 'Not provided',
                    },
                    onEditPressed: () => _showEditContactDialog(context),
                  ),
                  const SizedBox(height: 16),

                  // App Preferences Card
                  const ProfileInfoCard(
                    title: 'App Preferences',
                    icon: Icons.settings,
                    items: {
                      'Language': 'English',
                      'Notifications': 'Enabled',
                      'Theme': 'Light',
                    },
                  ),
                  const SizedBox(height: 16),

                  // Account Status Card
                  ProfileInfoCard(
                    title: 'Account Status',
                    icon: Icons.info_outline,
                    items: {
                      'Status': 'Active',
                      'Member Since': '2023',
                      'Last Login': 'Today',
                    },
                  ),

                  const SizedBox(height: 32),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    final nameController = TextEditingController(text: cubit.state.name);
    final emailController = TextEditingController(text: cubit.state.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              cubit.updateProfile(
                name: nameController.text,
                email: emailController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditContactDialog(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    final phoneController = TextEditingController(text: cubit.state.phone);
    final addressController = TextEditingController(text: cubit.state.address);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Contact Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              cubit.updateProfile(
                phone: phoneController.text,
                address: addressController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
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
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate back and trigger logout
              Navigator.pop(context);
              // You can trigger logout here or let the parent handle it
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}