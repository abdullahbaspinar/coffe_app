import 'package:coffe_app/model/user_profile.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;

  ProfileLoaded(this.profile);
}

class ProfileUpdating extends ProfileState {
  final UserProfile profile;

  ProfileUpdating(this.profile);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
