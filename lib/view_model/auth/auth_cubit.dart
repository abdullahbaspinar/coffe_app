import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffe_app/core/services/auth_service.dart';
import 'package:coffe_app/core/services/profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  final ProfileService _profileService;
  StreamSubscription<User?>? _authSubscription;

  AuthCubit({
    AuthService? authService,
    ProfileService? profileService,
  })  : _authService = authService ?? AuthService(),
        _profileService = profileService ?? ProfileService(),
        super(AuthState.initial()) {
    _listenAuthChanges();
  }

  User? get currentUser => state.user ?? _authService.currentUser;

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  String get currentUserName => currentUser?.displayName ?? 'Misafir';

  void _listenAuthChanges() {
    _authSubscription = _authService.authStateChanges.listen((user) {
      if (user == null) {
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            clearUser: true,
            isLoading: false,
            clearError: true,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          isLoading: false,
          clearError: true,
        ),
      );
    });
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) {
    return _runAuthAction(
      action: () => _authService.signIn(
        email: email.trim(),
        password: password.trim(),
      ),
    );
  }

  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return _runAuthAction(
      action: () async {
        await _authService.signUp(
          name: name.trim(),
          email: email.trim(),
          password: password.trim(),
        );

        await _profileService.createProfile(
          name: name.trim(),
          email: email.trim(),
        );
      },
    );
  }

  Future<String?> resetPassword({
    required String email,
  }) {
    return _runAuthAction(
      action: () => _authService.resetPassword(
        email: email.trim(),
      ),
    );
  }

  Future<void> signOut() async {
    await _authService.signOut();
    emit(AuthState.initial().copyWith(status: AuthStatus.unauthenticated));
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  Future<String?> _runAuthAction({
    required Future<void> Function() action,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        clearError: true,
      ),
    );

    try {
      await action();

      emit(
        state.copyWith(
          isLoading: false,
          status: AuthStatus.authenticated,
          user: _authService.currentUser,
          clearError: true,
        ),
      );

      return null;
    } on FirebaseAuthException catch (e) {
      final message = _mapFirebaseError(e);

      emit(
        state.copyWith(
          isLoading: false,
          status: AuthStatus.unauthenticated,
          errorMessage: message,
        ),
      );

      return message;
    } catch (_) {
      const message = 'Beklenmeyen bir hata oluştu.';

      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: message,
        ),
      );

      return message;
    }
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Geçersiz e-posta adresi.';
      case 'user-not-found':
        return 'Bu kullanıcı bulunamadı.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-posta veya şifre hatalı.';
      case 'email-already-in-use':
        return 'Bu e-posta zaten kayıtlı.';
      case 'weak-password':
        return 'Şifre çok zayıf.';
      case 'too-many-requests':
        return 'Çok fazla deneme yapıldı. Lütfen sonra tekrar dene.';
      default:
        return e.message ?? 'Bir hata oluştu.';
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}