import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/view/auth/mixin/sign_in_page_mixin.dart';
import 'package:coffe_app/view_model/auth/auth_cubit.dart';
import 'package:coffe_app/view_model/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with SignInPageMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
                    body: SafeArea(
            child: Padding(
              padding: AppSpacing.padding24,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSignInLogo,
                    const Spacer(),
                    _buildSignInText,
                    const SizedBox(height: AppSpacing.s8),
                    _buildSignInTextDescription,
                    const SizedBox(height: AppSpacing.s16),
                    _buildSignInUsernameLabel,
                    const SizedBox(height: AppSpacing.s16),
                    _buildSignInUsernameField,
                    const SizedBox(height: AppSpacing.s16),
                    _buildSignInPasswordLabel,
                    const SizedBox(height: AppSpacing.s16),
                    _buildSignInPasswordField,
                    const SizedBox(height: AppSpacing.s16),
                    _buildLoginButton(state),
                    const SizedBox(height: AppSpacing.s8),
                    _buildResetPasswordRow,
                    const Spacer(),
                    _buildCreateAccountText,
                    const SizedBox(height: AppSpacing.s16),
                    _buildCreateAccountButton,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget get _buildSignInLogo {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/logo.png", width: 48, height: 48),
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

  Widget get _buildSignInText {
    return Row(
      children: [
        Text(
          "Sign In",
          style: TextStyle(
            fontWeight: AppTypography.bold,
            color: context.appTextPrimary,
            fontSize: AppTypography.size24,
          ),
        ),
      ],
    );
  }

  Widget get _buildSignInTextDescription {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Lorem lorem lorem lorem lorem Lorem lorem lorem lorem Lorem lorem lorem lorem",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: AppTypography.regular,
              color: context.appTextPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget get _buildSignInUsernameLabel {
    return Row(
      children: [
        Text(
          "Username",
          style: TextStyle(
            fontSize: AppTypography.size16,
            color: context.appTextMuted,
            fontWeight: AppTypography.regular,
          ),
        ),
      ],
    );
  }

  Widget get _buildSignInUsernameField {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
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
                borderRadius: BorderRadius.all(AppRadius.corner(AppRadius.size16)),
                borderSide: BorderSide(
                  color: context.appPrimary,
                  width: 1.5,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Email boş bırakılamaz";
              }

              final email = value.trim();

              if (!email.contains("@") || !email.contains(".")) {
                return "Geçerli email adresi giriniz";
              }

              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget get _buildSignInPasswordLabel {
    return Row(
      children: [
        Text(
          "Password",
          style: TextStyle(
            fontSize: AppTypography.size16,
            color: context.appTextMuted,
            fontWeight: AppTypography.regular,
          ),
        ),
      ],
    );
  }

  Widget get _buildSignInPasswordField {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: passwordController,
            obscureText: isPasswordHidden,
            decoration: InputDecoration(
              hintText: "Password",
              filled: true,
              fillColor: context.appInputFill,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              suffixIcon: IconButton(
                onPressed: togglePasswordVisibility,
                icon: Icon(
                  isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                  color: context.appPrimary,
                ),
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
                borderRadius: BorderRadius.all(AppRadius.corner(AppRadius.size16)),
                borderSide: BorderSide(
                  color: context.appPrimary,
                  width: 1.5,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Şifre boş bırakılamaz";
              }

              if (value.trim().length < 6) {
                return "Şifre en az 6 karakterden oluşmalı";
              }

              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(AuthState state) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: state.isLoading ? null : handleSignIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.appPrimary,
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
                "LOGIN",
                style: TextStyle(
                  fontSize: AppTypography.size18,
                  fontWeight: AppTypography.semiBold,
                  color: context.appSecondary,
                ),
              ),
      ),
    );
  }

  Widget get _buildResetPasswordRow {
    return Row(
      children: [
        Text(
          "Forgot password ? ",
          style: TextStyle(
            fontSize: AppTypography.size14,
            fontWeight: AppTypography.regular,
            color: context.appTextMuted,
          ),
        ),
        TextButton(
          onPressed: openResetPassword,
          child: Text(
            "Reset Password",
            style: TextStyle(
              color: context.appPrimary,
              fontWeight: AppTypography.regular,
              fontSize: AppTypography.size14,
            ),
          ),
        ),
      ],
    );
  }

  Widget get _buildCreateAccountText {
    return Center(
      child: Text(
        "Don't have any account ? ",
        style: TextStyle(
          fontSize: AppTypography.size14,
          fontWeight: AppTypography.regular,
          color: context.appTextMuted,
        ),
      ),
    );
  }

  Widget get _buildCreateAccountButton {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: openSignUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.createAccountBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.border(AppRadius.size18),
          ),
          elevation: 0,
        ),
        child: Text(
          "CREATE ACCOUNT",
          style: TextStyle(
            fontSize: AppTypography.size18,
            fontWeight: AppTypography.semiBold,
            color: context.appTextPrimary,
          ),
        ),
      ),
    );
  }
}