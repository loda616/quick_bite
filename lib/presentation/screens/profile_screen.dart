import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/view_models/cubit/profile_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/profile_state.dart';
import 'package:quick_bite/presentation/widgets/profile/profile_header.dart';
import 'package:quick_bite/presentation/widgets/profile/profile_info_card.dart';
import 'package:quick_bite/theme/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("profile.title" ),
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
                ProfileHeader(name: state.name ?? "profile.guest" ),
                const SizedBox(height: 24),
                ProfileInfoCard(
                  title: "profile.personal_info" ,
                  items: {
                    "profile.email" : state.email ?? 'N/A',
                    "profile.phone" : state.phone ?? 'N/A',
                    "profile.address" : state.address ?? 'N/A',
                  },
                  onEditPressed: () {},
                ),
                const SizedBox(height: 16),
                ProfileInfoCard(
                  title: "profile.preferences" ,
                  items: {
                    "profile.language" : 'English',
                    "profile.notifications" : 'Enabled',
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
