import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/view/auth/mixin/reset_password_page_mixin.dart';
import 'package:coffe_app/view_model/auth/auth_cubit.dart';
import 'package:coffe_app/view_model/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage>
    with ResetPasswordPageMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
                    body: SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.padding24,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLogoHeader(),
                    const SizedBox(height: AppSpacing.s32),
                    _buildTitle(),
                    const SizedBox(height: AppSpacing.s8),
                    _buildDescription(),
                    const SizedBox(height: AppSpacing.s32),
                    _buildEmailLabel(),
                    const SizedBox(height: AppSpacing.s12),
                    _buildEmailField(),
                    const SizedBox(height: AppSpacing.s24),
                    _buildSubmitButton(state),
                    const SizedBox(height: AppSpacing.s24),
                    _buildLoginRedirect(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/logo.png",
          width: 48,
          height: 48,
        ),
        SizedBox(width: AppSpacing.s8),
        Text(
          "Ombe",
          style: TextStyle(
            color: context.appTextPrimary,
            fontSize: AppTypography.size24,
            fontWeight: AppTypography.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      "Forgot Password",
      style: TextStyle(
        fontWeight: AppTypography.bold,
        color: context.appTextPrimary,
        fontSize: AppTypography.size24,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      "Enter your email address and we will send a reset link.",
      style: TextStyle(
        fontWeight: AppTypography.regular,
        color: context.appTextPrimary,
        fontSize: AppTypography.size15,
      ),
    );
  }

  Widget _buildEmailLabel() {
    return Text(
      "Email",
      style: TextStyle(
        fontSize: AppTypography.size16,
        color: context.appTextMuted,
        fontWeight: AppTypography.regular,
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: "Email Address",
        filled: true,
        fillColor: context.appInputFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.border(AppRadius.size16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.border(AppRadius.size16),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.border(AppRadius.size16),
          borderSide: BorderSide(
            color: context.appPrimary,
            width: 1.5,
          ),
        ),
      ),
      validator: validateEmail,
    );
  }

  Widget _buildSubmitButton(AuthState state) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: state.isLoading ? null : handleResetPassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.appPrimary,
          disabledBackgroundColor: AppColors.primaryDisabled,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.border(AppRadius.size18),
          ),
          elevation: 0,
        ),
        child: state.isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: context.appSecondary,
                ),
              )
            : Text(
                "SUBMIT",
                style: TextStyle(
                  fontSize: AppTypography.size18,
                  fontWeight: AppTypography.semiBold,
                  color: context.appSecondary,
                ),
              ),
      ),
    );
  }

  Widget _buildLoginRedirect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            "Sign in to your registered account",
            style: TextStyle(
              fontSize: AppTypography.size15,
              fontWeight: AppTypography.regular,
              color: context.appTextMuted,
            ),
          ),
        ),
        TextButton(
          onPressed: openSignIn,
          child: Text(
            "Login here",
            style: TextStyle(
              fontSize: AppTypography.size15,
              fontWeight: AppTypography.regular,
              color: context.appPrimary,
            ),
          ),
        ),
      ],
    );
  }
}