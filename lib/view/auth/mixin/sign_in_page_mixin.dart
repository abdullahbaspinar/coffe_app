import 'package:coffe_app/core/router/app_router.dart';
import 'package:coffe_app/core/router/app_routes.dart';
import 'package:coffe_app/view/auth/sign_in_page.dart';
import 'package:coffe_app/view_model/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin SignInPageMixin on State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPasswordHidden = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    setState(() => isPasswordHidden = !isPasswordHidden);
  }

  Future<void> handleSignIn() async {
    if (!formKey.currentState!.validate()) return;

    final result = await context.read<AuthCubit>().signIn(
          email: emailController.text,
          password: passwordController.text,
        );

    if (!mounted) return;

    if (result == null) {
      AppRouter.goNamed(AppRoutes.home.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  void openResetPassword() {
    AppRouter.navigatePushNamed(AppRoutes.resetPassword.path);
  }

  void openSignUp() {
    AppRouter.navigatePushNamed(AppRoutes.signUp.path);
  }
}
