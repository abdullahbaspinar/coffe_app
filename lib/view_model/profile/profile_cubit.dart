import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe_app/core/services/profile_service.dart';
import 'package:coffe_app/model/user_profile.dart';
import 'package:coffe_app/view_model/profile/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileService _service;

  ProfileCubit({ProfileService? service})
      : _service = service ?? ProfileService(),
        super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await _service.getProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(_formatError(e)));
    }
  }

  Future<String?> updateProfile({
    required String name,
    required String email,
    int? phone,
    String? address,
  }) async {
    final previousProfile = _currentProfile;
    if (previousProfile != null) {
      emit(ProfileUpdating(previousProfile));
    }

    try {
      final updated = await _service.updateProfile(
        name: name,
        email: email,
        phone: phone,
        address: address,
      );

      emit(ProfileLoaded(updated));
      return null;
    } catch (e) {
      if (previousProfile != null) {
        emit(ProfileLoaded(previousProfile));
      } else {
        try {
          final profile = await _service.getProfile();
          emit(ProfileLoaded(profile));
        } catch (_) {
          emit(ProfileError(_formatError(e)));
        }
      }
      return _formatError(e);
    }
  }

  UserProfile? get _currentProfile {
    final current = state;
    if (current is ProfileLoaded) return current.profile;
    if (current is ProfileUpdating) return current.profile;
    return null;
  }

  String _formatError(Object e) {
    if (e is FirebaseException) {
      return ProfileService.mapFirebaseError(e);
    }

    final message = e.toString();
    return message.replaceFirst('Exception: ', '');
  }
}
