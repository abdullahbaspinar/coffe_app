import 'package:coffe_app/constants/app_colors.dart';
import 'package:coffe_app/view/auth/sign_in_page.dart';
import 'package:coffe_app/view/widgets/social_login_button.dart';
import 'package:flutter/material.dart';

class AuthChoicePage extends StatefulWidget {
  const AuthChoicePage({super.key});

  @override
  State<AuthChoicePage> createState() => _AuthChoicePageState();
}

class _AuthChoicePageState extends State<AuthChoicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              _buildAuthChoiceLogo,
              const SizedBox(height: 8),
              _buildAuthChoiceAppName,
              const SizedBox(height: 8),
              _buildAuthChoiceAppDescription,
              const SizedBox(height: 20),
              _buildAuthChoiceTitle,
              const Spacer(),
              _buildAuthChoiceEmailButton,
              const SizedBox(height: 30),
              _buildAuthChoiceFacebookButton,
              const SizedBox(height: 6),
              _buildAuthChoiceGoogleButton,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _buildAuthChoiceLogo {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Image.asset(
        "assets/images/logo.png",
        height: 200,
        width: double.infinity,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget get _buildAuthChoiceAppName {
    return const Text(
      "Ombe",
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget get _buildAuthChoiceAppDescription {
    return const Text(
      "Coffe Shop App",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.grey,
      ),
    );
  }

  Widget get _buildAuthChoiceTitle {
    return const Text(
      "Morning begins with ombe coffee",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black,
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
        backgroundColor: AppColors.primaryColor,
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
        backgroundColor: AppColors.backgroundColor,
        textColor: AppColors.primaryColor,
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInPage(),
            ),
          );
        },
        borderColor: Colors.grey.shade300,
      ),
    );
  }
}