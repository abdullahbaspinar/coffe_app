import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/core/router/app_router.dart';
import 'package:coffe_app/core/router/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
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

    if (isFirstLaunch) {
      AppRouter.goNamed(AppRoutes.onboarding.path);
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    AppRouter.goNamed(
      user != null ? AppRoutes.home.path : AppRoutes.auth.path,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.coffee, size: 70, color: context.appPrimary),
            const SizedBox(height: AppSpacing.s16),
            Text(
              'Ombe',
              style: TextStyle(
                color: context.appPrimary,
                fontSize: AppTypography.size36,
                fontWeight: AppTypography.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
