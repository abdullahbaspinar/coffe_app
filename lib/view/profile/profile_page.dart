import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
import 'package:coffe_app/model/user_profile.dart';
import 'package:coffe_app/view/profile/mixin/profile_page_mixin.dart';
import 'package:coffe_app/view/widgets/most_ordered_card.dart';
import 'package:coffe_app/view/widgets/personal_information_card.dart';
import 'package:coffe_app/view_model/profile/profile_cubit.dart';
import 'package:coffe_app/view_model/profile/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with ProfilePageMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: profileCubit,
      child: Scaffold(
        backgroundColor: context.appBackground,
        appBar: _buildAppBar,
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading || state is ProfileInitial) {
                return Center(
                  child: CircularProgressIndicator(color: context.appPrimary),
                );
              }

              if (state is ProfileError) {
                return _buildErrorState(state.message);
              }

              if (state is ProfileLoaded || state is ProfileUpdating) {
                final profile = state is ProfileLoaded
                    ? state.profile
                    : (state as ProfileUpdating).profile;
                return _buildLoadedContent(profile);
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget get _buildAppBar {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: context.appBackground,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: IconButton(
          onPressed: () => closePage(),
          icon: Icon(Icons.arrow_back_ios_new, color: context.appTextPrimary),
        ),
      ),
      title: Text(
        'Profile',
        style: TextStyle(
          color: context.appTextPrimary,
          fontSize: AppTypography.size22,
          fontWeight: AppTypography.bold,
        ),
      ),
      actions: [
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final profile = profileFromState(state);

            return IconButton(
              onPressed: profile != null ? () => openEditPage(profile) : null,
              icon: Icon(Icons.edit, color: context.appTextPrimary),
            );
          },
        ),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: AppSpacing.padding20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 56,
              color: context.appTextMuted,
            ),
            const SizedBox(height: AppSpacing.s16),
            Text(
              message.replaceFirst('Exception: ', ''),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.appTextPrimary,
                fontSize: AppTypography.size16,
              ),
            ),
            const SizedBox(height: AppSpacing.s20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: reloadProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.appPrimary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.border(AppRadius.size30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Tekrar Dene',
                  style: TextStyle(fontWeight: AppTypography.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedContent(UserProfile profile) {
    return SingleChildScrollView(
      padding: AppSpacing.padding20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopSection(profile),
          const SizedBox(height: AppSpacing.s8),
          _buildMidSection(profile),
          const SizedBox(height: AppSpacing.s16),
          Text(
            'MOST ORDERED',
            style: TextStyle(
              color: context.appTextPrimary,
              fontSize: AppTypography.size16,
              fontWeight: AppTypography.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          SizedBox(height: 100, child: _buildBottomSection),
        ],
      ),
    );
  }

  Widget _buildTopSection(UserProfile profile) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 75,
            backgroundColor: context.appPrimaryTint,
            child: Icon(
              Icons.person_rounded,
              size: 72,
              color: context.appPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            profile.name.isNotEmpty ? profile.name : 'Misafir',
            style: TextStyle(
              color: context.appTextPrimary,
              fontSize: AppTypography.size22,
              fontWeight: AppTypography.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            profile.address?.isNotEmpty == true
                ? profile.address!
                : 'Adres eklenmedi',
            style: TextStyle(
              color: context.appPrimary,
              fontSize: AppTypography.size16,
              fontWeight: AppTypography.semiBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMidSection(UserProfile profile) {
    return Column(
      children: [
        PersonalInformationCard(
          iconName: Icons.phone_iphone,
          title: 'Mobile Phone',
          description: profile.phone != null
              ? profile.phone.toString()
              : 'Telefon eklenmedi',
        ),
        const SizedBox(height: AppSpacing.s8),
        PersonalInformationCard(
          iconName: Icons.email_outlined,
          title: 'Email Adress',
          description: profile.email.isNotEmpty
              ? profile.email
              : 'Email eklenmedi',
        ),
        const SizedBox(height: AppSpacing.s8),
        PersonalInformationCard(
          iconName: Icons.location_on_outlined,
          title: 'Adress',
          description: profile.address?.isNotEmpty == true
              ? profile.address!
              : 'Adres eklenmedi',
        ),
      ],
    );
  }

  Widget get _buildBottomSection {
    return SizedBox(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: const [
            MostOrderedCard(
              imagePath: 'assets/product/product1.png',
              title: 'Iced Latte',
              category: 'Beverages',
            ),
            SizedBox(width: AppSpacing.s8),
            MostOrderedCard(
              imagePath: 'assets/product/product1.png',
              title: 'Iced Latte',
              category: 'Beverages',
            ),
            SizedBox(width: AppSpacing.s8),
            MostOrderedCard(
              imagePath: 'assets/product/product1.png',
              title: 'Iced Latte',
              category: 'Beverages',
            ),
          ],
        ),
      ),
    );
  }
}