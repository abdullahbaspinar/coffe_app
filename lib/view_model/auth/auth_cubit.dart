import 'package:bloc/bloc.dart';
import 'package:coffe_app/core/services/auth_service.dart';
import 'package:coffe_app/core/services/profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit({
    AuthService? authService,
  })  : _authService = authService ?? AuthService(),
        super(AuthState.initial());

  User? get currentUser => _authService.currentUser;

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  String get currentUserName => currentUser?.displayName ?? "Misafir";

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      emit(state.copyWith(
        isLoading: true,
        errorMessage: null,
      ));

      await _authService.signIn(
        email: email.trim(),
        password: password.trim(),
      );

      emit(state.copyWith(
        isLoading: false,
        user: _authService.currentUser,
        errorMessage: null,
      ));

      return null;
    } on FirebaseAuthException catch (e) {
      final message = _mapFirebaseError(e);

      emit(state.copyWith(
        isLoading: false,
        errorMessage: message,
      ));

      return message;
    } catch (_) {
      const message = 'Beklenmeyen bir hata oluştu.';

      emit(state.copyWith(
        isLoading: false,
        errorMessage: message,
      ));

      return message;
    }
  }

  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(state.copyWith(
        isLoading: true,
        errorMessage: null,
      ));

      await _authService.signUp(
        name: name.trim(),
        email: email.trim(),
        password: password.trim(),
      );

      await ProfileService().createProfile(
        name: name.trim(),
        email: email.trim(),
      );

      emit(state.copyWith(
        isLoading: false,
        user: _authService.currentUser,
        errorMessage: null,
      ));

      return null;
    } on FirebaseAuthException catch (e) {
      final message = _mapFirebaseError(e);

      emit(state.copyWith(
        isLoading: false,
        errorMessage: message,
      ));

      return message;
    } catch (_) {
      const message = 'Beklenmeyen bir hata oluştu.';

      emit(state.copyWith(
        isLoading: false,
        errorMessage: message,
      ));

      return message;
    }
  }

  Future<String?> resetPassword({
    required String email,
  }) async {
    try {
      emit(state.copyWith(
        isLoading: true,
        errorMessage: null,
      ));

      await _authService.resetPassword(
        email: email.trim(),
      );

      emit(state.copyWith(
        isLoading: false,
        errorMessage: null,
      ));

      return null;
    } on FirebaseAuthException catch (e) {
      final message = _mapFirebaseError(e);

      emit(state.copyWith(
        isLoading: false,
        errorMessage: message,
      ));

      return message;
    } catch (_) {
      const message = 'Beklenmeyen bir hata oluştu.';

      emit(state.copyWith(
        isLoading: false,
        errorMessage: message,
      ));

      return message;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();

    emit(AuthState.initial());
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
}
