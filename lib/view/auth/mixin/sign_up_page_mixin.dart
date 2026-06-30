import 'package:coffe_app/core/router/app_router.dart';
import 'package:coffe_app/core/router/app_routes.dart';
import 'package:coffe_app/view/auth/sign_up_page.dart';
import 'package:coffe_app/view_model/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin SignUpPageMixin on State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPasswordHidden = true;
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(checkForm);
    emailController.addListener(checkForm);
    passwordController.addListener(checkForm);
  }

  void checkForm() {
    setState(() {
      isFormValid = nameController.text.trim().isNotEmpty &&
          emailController.text.trim().isNotEmpty &&
          passwordController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    nameController.removeListener(checkForm);
    emailController.removeListener(checkForm);
    passwordController.removeListener(checkForm);
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    setState(() => isPasswordHidden = !isPasswordHidden);
  }

  Future<void> handleSignUp() async {
    if (!formKey.currentState!.validate()) return;

    final result = await context.read<AuthCubit>().signUp(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
        );

    if (!mounted) return;

    if (result == null) {
      AppRouter.goNamed(AppRoutes.signIn.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }
}
