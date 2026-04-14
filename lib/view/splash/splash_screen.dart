import 'dart:async';
import 'package:coffe_app/constants/app_colors.dart';
import 'package:coffe_app/view/home/home_page.dart';
import 'package:coffe_app/view/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goToHome();
  }

  void _goToHome() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_buildSplahLogo, const SizedBox(height: 16),_buildSplashText],
          ),
        ),
      ),
    );
  }
}

Widget get _buildSplahLogo {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [Image.asset("assets/images/logo.png",)],
  );
}

Widget get _buildSplashText {
  return Text(
    "OMBE",
    style: TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      color: AppColors.primaryColor,
    ),
  );
}
