import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/view_models/cubit/profile_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/profile_state.dart';
import 'package:quick_bite/presentation/widgets/profile/profile_info_card.dart';

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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: theme.colorScheme.error,
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
            return Scaffold(
              appBar: _buildAppBar(context, theme),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Loading profile...',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                // Enhanced Theme-Aware App Bar Header
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: isDarkMode ? Colors.black : Colors.white,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Background Pattern
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0.1,
                              child: Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="20" cy="20" r="2" fill="white"/><circle cx="80" cy="20" r="2" fill="white"/><circle cx="20" cy="80" r="2" fill="white"/><circle cx="80" cy="80" r="2" fill="white"/><circle cx="50" cy="50" r="3" fill="white"/></svg>',
                                    ),
                                    repeat: ImageRepeat.repeat,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Profile Content in Header
                          Positioned(
                            bottom: 60,
                            left: 20,
                            right: 20,
                            child: Column(
                              children: [
                                // Profile Avatar
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (isDarkMode ? Colors.black : Colors.white).withOpacity(0.2),
                                    border: Border.all(
                                      color: isDarkMode ? Colors.black : Colors.white,
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 40,
                                    color: isDarkMode ? Colors.black : Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // User Name
                                Text(
                                  state.name ?? 'Guest User',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.black : Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                // User Role
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (isDarkMode ? Colors.black : Colors.white).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    state.role ?? 'User',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isDarkMode ? Colors.black : Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.refresh_outlined,
                        color: isDarkMode ? Colors.black : Colors.white,
                      ),
                      onPressed: () {
                        context.read<ProfileCubit>().refreshProfile();
                      },
                      tooltip: 'Refresh Profile',
                    ),
                  ],
                ),

                // Profile Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

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
                        ProfileInfoCard(
                          title: 'App Preferences',
                          icon: Icons.settings,
                          items: {
                            'Language': 'English',
                            'Notifications': 'Enabled',
                            'Theme': isDarkMode ? 'Dark' : 'Light',
                          },
                        ),
                        const SizedBox(height: 16),

                        // Account Status Card
                        const ProfileInfoCard(
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
                              backgroundColor: theme.colorScheme.error,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              elevation: 2,
                              shadowColor: theme.colorScheme.error.withOpacity(0.3),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      title: const Text('Profile'),
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      titleTextStyle: theme.textTheme.titleLarge?.copyWith(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.bold,
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}