import 'package:coffe_app/constants/app_colors.dart';
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
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(24),
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                "Ombe",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Coffe Shop App",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Morning begins with ombe coffee",
                textAlign: .center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: SocialLoginButton(
                  text: "Login with Email",
                  iconPath: "assets/images/inbox.png",
                  backgroundColor: AppColors.primaryColor,
                  textColor: AppColors.backgroundColor,
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: SocialLoginButton(
                  text: "Login with Facebook",
                  iconPath: "assets/images/logos/facebook_logo_white.png",
                  backgroundColor: AppColors.facebookColor,
                  textColor: AppColors.backgroundColor,
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 6),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: SocialLoginButton(
                  text: "Login with Google",
                  iconPath: "assets/images/logos/google_logo.png",
                  backgroundColor: AppColors.backgroundColor,
                  textColor: AppColors.primaryColor,
                  onTap: () {},
                  borderColor: Colors.grey.shade300,
                  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
