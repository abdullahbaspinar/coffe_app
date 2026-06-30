import 'package:coffe_app/core/router/app_router.dart';
import 'package:coffe_app/core/router/app_routes.dart';
import 'package:coffe_app/core/services/profile_service.dart';
import 'package:coffe_app/model/user_profile.dart';
import 'package:coffe_app/view/profile/profile_page.dart';
import 'package:coffe_app/view_model/profile/profile_cubit.dart';
import 'package:coffe_app/view_model/profile/profile_state.dart';
import 'package:flutter/material.dart';

mixin ProfilePageMixin on State<ProfilePage> {
  final ProfileCubit profileCubit = ProfileCubit(service: ProfileService());

  @override
  void initState() {
    super.initState();
    profileCubit.loadProfile();
  }

  @override
  void dispose() {
    profileCubit.close();
    super.dispose();
  }

  void openEditPage(UserProfile profile) {
    AppRouter.navigatePushNamed(
      AppRoutes.profileEdit.path,
      extra: ProfileEditExtra(profile: profile, cubit: profileCubit),
    );
  }

  void reloadProfile() {
    profileCubit.loadProfile();
  }

  void closePage() {
    AppRouter.pop();
  }

  UserProfile? profileFromState(ProfileState state) {
    return switch (state) {
      ProfileLoaded(:final profile) => profile,
      ProfileUpdating(:final profile) => profile,
      _ => null,
    };
  }
}
