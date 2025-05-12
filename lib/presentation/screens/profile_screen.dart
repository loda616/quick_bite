import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quick_bite/presentation/view_models/cubit/profile_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/profile_state.dart';
import 'package:quick_bite/presentation/widgets/profile/profile_header.dart';
import 'package:quick_bite/presentation/widgets/profile/profile_info_card.dart';
import 'package:quick_bite/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        backgroundColor: const Color(0xFFf8f1df),
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.accentColor),
        titleTextStyle: const TextStyle(
          color: AppTheme.accentColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.isLoading && state.name == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Center(child: Text(state.errorMessage!));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ProfileHeader(name: state.name ?? l10n.guest),
                const SizedBox(height: 24),
                ProfileInfoCard(
                  title: l10n.personalInfo,
                  items: {
                    l10n.email: state.email ?? 'N/A',
                    l10n.phone: state.phone ?? 'N/A',
                    l10n.address: state.address ?? 'N/A',
                  },
                  onEditPressed: () {} //() => _showEditProfileDialog(context),
                ),
                const SizedBox(height: 16),
                ProfileInfoCard(
                  title: l10n.preferences,
                  items: {
                    l10n.language: 'English',
                    l10n.notifications: 'Enabled',
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

//  void _showEditProfileDialog(BuildContext context) {
//     final cubit = context.read<ProfileCubit>();
//     showDialog(
//       context: context,
//       builder: (context) => EditProfileDialog(
//         initialName: cubit.state.name,
//         initialEmail: cubit.state.email,
//         initialPhone: cubit.state.phone,
//         initialAddress: cubit.state.address,
//         onSave: (name, email, phone, address) {
//           cubit.updateProfile(
//             name: name,
//             email: email,
//             phone: phone,
//             address: address,
//           );
//         },
//       ),
//     );
//   }
}