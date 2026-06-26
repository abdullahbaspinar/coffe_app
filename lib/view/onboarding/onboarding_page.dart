import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/core/router/app_router.dart';
import 'package:coffe_app/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/onboarding_1.svg",
      "title": "Lets meet our summer coffe drinks",
      "description":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard ",
    },
    {
      "image": "assets/images/onboarding_2.svg",
      "title": "Start your morning with great coffee",
      "description":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard ",
    },
    {
      "image": "assets/images/onboarding_3.svg",
      "title": "Best coffe shop in this town",
      "description":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard ",
    },
  ];

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isFirstLaunch", false);

    if (!mounted) return;

    AppRouter.goNamed(AppRoutes.auth.path);
  }

  void nextPage() {
    if (currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void skipOnboarding() {
    _finishOnboarding();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: SafeArea(
        child: Padding(
          padding: AppSpacing.padding30,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: skipOnboarding,
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      color: context.appPrimary,
                      fontSize: AppTypography.size16,
                      fontWeight: AppTypography.semiBold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingData.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final item = onboardingData[index];

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: AppRadius.border(AppRadius.size24),
                          child: SvgPicture.asset(
                            item["image"]!,
                            height: 300,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: AppSpacing.s40),
                        Text(
                          item["title"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppTypography.size28,
                            fontWeight: AppTypography.bold,
                            color: context.appPrimary,
                          ),
                        ),
                        SizedBox(height: AppSpacing.s16),
                        Text(
                          item["description"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: context.appPrimary,
                            fontSize: AppTypography.size16,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 10,
                    width: currentPage == index ? 24 : 10,
                    decoration: BoxDecoration(
                      color: currentPage == index
                          ? AppColors.secondaryColor
                          : AppColors.textDisabled,
                      borderRadius: AppRadius.border(AppRadius.size12),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.s32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.appPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.border(AppRadius.size18),
                    ),
                  ),
                  child: Text(
                    currentPage == onboardingData.length - 1
                        ? "Get started"
                        : "Next",
                    style: const TextStyle(
                      fontSize: AppTypography.size18,
                      fontWeight: AppTypography.semiBold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}