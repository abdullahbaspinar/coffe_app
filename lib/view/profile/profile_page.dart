import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/view/widgets/most_ordered_card.dart';
import 'package:coffe_app/view/widgets/personal_information_card.dart';
import 'package:flutter/material.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_typography.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: _buildAppBar,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopSection,
              SizedBox(height: AppSpacing.s8),
              _buildMidSection,
              SizedBox(height: AppSpacing.s16),
              Text(
                "MOST ORDERED",
                style: TextStyle(
                  color: context.appTextPrimary,
                  fontSize: AppTypography.size16,
                  fontWeight: AppTypography.bold,
                ),
              ),
              SizedBox(height: AppSpacing.s8),
              _buildBottomSection,
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget get _buildAppBar {
    return AppBar(
            elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: EdgeInsetsGeometry.only(left: 12),
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: context.appTextPrimary),
        ),
      ),
      title: Text(
        "Profile",
        style: TextStyle(
          color: context.appTextPrimary,
          fontSize: AppTypography.size22,
          fontWeight: AppTypography.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.edit, color: context.appTextPrimary),
        ),
      ],
    );
  }

  Widget get _buildTopSection {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 75,
            backgroundImage: AssetImage("assets/profile/profile_picture.png"),
          ),
          SizedBox(height: AppSpacing.s16),
          Text(
            "Abdullah Başpınar",
            style: TextStyle(
              color: context.appTextPrimary,
              fontSize: AppTypography.size22,
              fontWeight: AppTypography.bold,
            ),
          ),
          SizedBox(height: AppSpacing.s16),
          Text(
            "Ankara, Turkey",
            style: TextStyle(
              color: context.appPrimary,
              fontSize: AppTypography.size16,
              fontWeight: AppTypography.semiBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget get _buildMidSection {
    return Column(
      children: [
        PersonalInformationCard(
          icon_name: Icons.phone_iphone,
          title: "Mobile Phone",
          description: "+90 551 343 29 10",
        ),
        SizedBox(height: AppSpacing.s8),
        PersonalInformationCard(
          icon_name: Icons.email_outlined,
          title: "Email Adress",
          description: "abdullahbaspinarr@gmail.com",
        ),
        SizedBox(height: AppSpacing.s8),
        PersonalInformationCard(
          icon_name: Icons.location_on_outlined,
          title: "Adress",
          description: "Ankara, Turkey",
        ),
      ],
    );
  }

  Widget get _buildBottomSection {
    return SizedBox(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            MostOrderedCard(
              imagePath: "assets/product/product1.png",
              title: "Iced Latte",
              category: "Beverages",
            ),
            SizedBox(width: AppSpacing.s8),
            MostOrderedCard(
              imagePath: "assets/product/product1.png",
              title: "Iced Latte",
              category: "Beverages",
            ),
            SizedBox(width: AppSpacing.s8),

            MostOrderedCard(
              imagePath: "assets/product/product1.png",
              title: "Iced Latte",
              category: "Beverages",
            ),
          ],
        ),
      ),
    );
  }
}
