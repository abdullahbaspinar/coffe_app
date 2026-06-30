import 'package:coffe_app/core/router/app_router.dart';
import 'package:coffe_app/core/router/app_routes.dart';
import 'package:coffe_app/view/auth/reset_password_page.dart';
import 'package:coffe_app/view_model/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin ResetPasswordPageMixin on State<ResetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> handleResetPassword() async {
    if (!formKey.currentState!.validate()) return;

    final result = await context.read<AuthCubit>().resetPassword(
          email: emailController.text.trim(),
        );

    if (!mounted) return;

    if (result == null) {
      showSnackBar('Şifre sıfırlama maili gönderildi.');
      AppRouter.goNamed(AppRoutes.signIn.path);
    } else {
      showSnackBar(result);
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void openSignIn() {
    AppRouter.navigatePushNamed(AppRoutes.signIn.path);
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email boş bırakılamaz';
    }

    final email = value.trim();
    if (!email.contains('@') || !email.contains('.')) {
      return 'Geçerli email adresi giriniz';
    }

    return null;
  }
}
