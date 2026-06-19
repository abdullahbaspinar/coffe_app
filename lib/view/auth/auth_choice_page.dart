import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/view/auth/sign_in_page.dart';
import 'package:coffe_app/view/widgets/social_login_button.dart';
import 'package:flutter/material.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_typography.dart';

class AuthChoicePage extends StatefulWidget {
  const AuthChoicePage({super.key});

  @override
  State<AuthChoicePage> createState() => _AuthChoicePageState();
}

class _AuthChoicePageState extends State<AuthChoicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: SafeArea(
        child: Padding(
          padding: AppSpacing.padding24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              _buildAuthChoiceLogo,
              const SizedBox(height: AppSpacing.s8),
              _buildAuthChoiceAppName,
              const SizedBox(height: AppSpacing.s8),
              _buildAuthChoiceAppDescription,
              const SizedBox(height: AppSpacing.s20),
              _buildAuthChoiceTitle,
              const Spacer(),
              _buildAuthChoiceEmailButton,
              const SizedBox(height: AppSpacing.s30),
              _buildAuthChoiceFacebookButton,
              const SizedBox(height: AppSpacing.s6),
              _buildAuthChoiceGoogleButton,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _buildAuthChoiceLogo {
    return ClipRRect(
      borderRadius: AppRadius.border(AppRadius.size24),
      child: Image.asset(
        "assets/images/logo.png",
        height: 200,
        width: double.infinity,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget get _buildAuthChoiceAppName {
    return Text(
      "Ombe",
      style: TextStyle(
        fontSize: AppTypography.size32,
        fontWeight: AppTypography.bold,
        color: context.appTextPrimary,
      ),
    );
  }

  Widget get _buildAuthChoiceAppDescription {
    return Text(
      "Coffe Shop App",
      style: TextStyle(
        fontSize: AppTypography.size15,
        fontWeight: AppTypography.regular,
        color: context.appTextMuted,
      ),
    );
  }

  Widget get _buildAuthChoiceTitle {
    return Text(
      "Morning begins with ombe coffee",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: AppTypography.size28,
        fontWeight: AppTypography.bold,
        color: context.appTextPrimary,
        height: 1.2,
      ),
    );
  }

  Widget get _buildAuthChoiceEmailButton {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: SocialLoginButton(
        text: "Login with Email",
        iconPath: "assets/images/inbox.png",
        backgroundColor: context.appPrimary,
        textColor: AppColors.backgroundColor,
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInPage(),
            ),
          );
        },
      ),
    );
  }

  Widget get _buildAuthChoiceFacebookButton {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: SocialLoginButton(
        text: "Login with Facebook",
        iconPath: "assets/images/logos/facebook_logo_white.png",
        backgroundColor: AppColors.facebookColor,
        textColor: AppColors.backgroundColor,
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInPage(),
            ),
          );
        },
      ),
    );
  }

  Widget get _buildAuthChoiceGoogleButton {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: SocialLoginButton(
        text: "Login with Google",
        iconPath: "assets/images/logos/google_logo.png",
        backgroundColor: context.appBackground,
        textColor: context.appPrimary,
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInPage(),
            ),
          );
        },
        borderColor: AppColors.border,
      ),
    );
  }
}