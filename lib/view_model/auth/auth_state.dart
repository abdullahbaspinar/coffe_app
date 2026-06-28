import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  unknown,          // uygulama ilk açıldı, henüz kontrol edilmedi
  authenticated,  // giriş yapılmış
  unauthenticated // giriş yok
}

class AuthState {
  final AuthStatus status;
  final bool isLoading;
  final User? user;
  final String? errorMessage;

  const AuthState({
    required this.status,
    required this.isLoading,
    required this.user,
    required this.errorMessage,
  });

  factory AuthState.initial() {
    return const AuthState(
      status: AuthStatus.unknown,
      isLoading: false,
      user: null,
      errorMessage: null,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;

  AuthState copyWith({
    AuthStatus? status,
    bool? isLoading,
    User? user,
    String? errorMessage,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}