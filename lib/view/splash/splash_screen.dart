import 'dart:async';
import 'package:coffe_app/constants/app_colors.dart';
import 'package:coffe_app/view/auth/auth_choice_page.dart';
import 'package:coffe_app/view/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final bool isFirstLaunch = prefs.getBool("isFirstLaunch") ?? true;

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            isFirstLaunch ? const OnboardingPage() : const AuthChoicePage(),
      ),
    );
  }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSplashScreen,
            const SizedBox(height: 16),
            _buildSplashText,
          ],
        ),
      ),
    );
  }
}

  Widget get _buildSplashScreen {
    return const Icon(
      Icons.coffee,
      size: 70,
      color: AppColors.primaryColor,
    );
  }

  Widget get _buildSplashText {
    return const Text(
      'Ombe',
      style: TextStyle(
        color: AppColors.primaryColor,
        fontSize: 36,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    );
  }

 