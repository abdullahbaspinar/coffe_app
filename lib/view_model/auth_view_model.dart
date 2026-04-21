import 'package:coffe_app/core/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? get currentUser => _authService.currentUser;

  Stream<User?> get authStateChanges => _authService.authStateChanges;
  

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);

      await _authService.signIn(
        email: email.trim(),
        password: password.trim(),
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseError(e);
    } catch (_) {
      return 'Beklenmeyen bir hata oluştu.';
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);

      await _authService.signUp(
        name: name.trim(),
        email: email.trim(),
        password: password.trim(),
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseError(e);
    } catch (_) {
      return 'Beklenmeyen bir hata oluştu.';
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> resetPassword({
    required String email,
  }) async {
    try {
      _setLoading(true);

      await _authService.resetPassword(
        email: email.trim(),
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseError(e);
    } catch (_) {
      return 'Beklenmeyen bir hata oluştu.';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
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
  
  String get currentUserName => currentUser?.displayName ?? "Guest";


}