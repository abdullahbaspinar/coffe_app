import 'auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthState {
  final bool isLoading;
  final User? user;
  final String? errorMessage;

  AuthState({
    required this.isLoading,
    required this.user,
    required this.errorMessage,
  });

  factory AuthState.initial() {
    return AuthState(isLoading: false, user: null, errorMessage: null);
  }
  AuthState copyWith({bool? isLoading, User? user, String? errorMessage}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,

      user: user ?? this.user,

      errorMessage: errorMessage,
    );
  }
}
