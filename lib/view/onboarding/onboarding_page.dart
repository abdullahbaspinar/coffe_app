import 'package:coffe_app/constants/app_colors.dart';
import 'package:coffe_app/view/auth/auth_choice_page.dart';
import 'package:coffe_app/view/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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

  void nextPage() {
    if (currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthChoicePage()),
      );
    }
  }

  void skipOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthChoicePage()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(30),
          child: Column(
            children: [
              Align(
                alignment: .topEnd,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
                          borderRadius: BorderRadius.circular(24),
                          child: SvgPicture.asset(
                            item["image"]!,
                            height: 300,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(height: 40,),
                        Text(item["title"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),),
                        const SizedBox(height: 16,),
                        Text(item["description"]!,textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.primaryColor,
                        fontSize: 16,
                        )
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
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32,),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(onPressed: nextPage,style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(18),  
                )), child: Text(currentPage ==onboardingData.length-1
                ?"Get started"
                :"Next",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white
                ),)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
