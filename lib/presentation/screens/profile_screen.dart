import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/view_models/cubit/profile_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/profile_state.dart';
import 'package:quick_bite/presentation/widgets/profile/profile_info_card.dart';

import '../../core/routs/app_routs.dart';
import '../../l10n/generated/app_localizations.dart';
import '../widgets/common/standard_app_bar.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: theme.colorScheme.error,
                action: SnackBarAction(
                  label: l10n.retry,
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
              appBar: _buildAppBar(context, theme, l10n),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.loadingProfile,
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
                      tooltip: l10n.refreshProfile,
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
                          l10n: l10n,
                          title: l10n.accountInformation,
                          icon: Icons.person,
                          items: {
                            l10n.fullName: state.name ?? 'N/A',
                            l10n.email: state.email ?? 'N/A',
                          },
                          onEditPressed: () => _showEditProfileDialog(context),
                        ),
                        const SizedBox(height: 16),

                        // Contact Information Card
                        ProfileInfoCard(
                          l10n: l10n,
                          title: l10n.contactInformation,
                          icon: Icons.contact_phone,
                          items: {
                            l10n.phone: state.phone ?? l10n.notProvided,
                            l10n.address: state.address ?? l10n.notProvided,
                          },
                          onEditPressed: () => _showEditContactDialog(context),
                        ),
                        const SizedBox(height: 16),



                        // Logout Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showLogoutDialog(context);
                            },
                            icon: const Icon(Icons.logout),
                            label: Text(l10n.logout),
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

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return StandardAppBar(
      title: l10n.profile,
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    final nameController = TextEditingController(text: cubit.state.name);
    final emailController = TextEditingController(text: cubit.state.email);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editProfile),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: l10n.fullName,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: l10n.email,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              cubit.updateProfile(
                name: nameController.text,
                email: emailController.text,
              );
              Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showEditContactDialog(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    final phoneController = TextEditingController(text: cubit.state.phone);
    final addressController = TextEditingController(text: cubit.state.address);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editContactInformation),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: l10n.phoneNumber,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: l10n.address,
                border: const OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              cubit.updateProfile(
                phone: phoneController.text,
                address: addressController.text,
              );
              Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              // Dismiss the dialog first
              Navigator.of(dialogContext).pop();

              // Call the logout method from the cubit
              context.read<ProfileCubit>().logout().then((_) {
                // Ensure the widget is still mounted before navigating
                if (!mounted) return;
                // Navigate to the auth screen and remove all previous routes
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRouts.auth,
                  (Route<dynamic> route) => false,
                );
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }
}
