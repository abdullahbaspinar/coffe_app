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
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                _buildSplashScreen,
                SizedBox(height: 16),
                _buildSplashText],
            ),
          ),
        ],
      ),
    );
  }
}

Widget get _buildSplashScreen {
  return Icon(Icons.coffee, size: 70, color: AppColors.primaryColor);
}

Widget get _buildSplashText {
  return Text(
    'Ombe',
    style: TextStyle(
      color: AppColors.primaryColor,
      fontSize: 36,
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
    ),
  );
}
