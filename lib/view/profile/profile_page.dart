import 'package:coffe_app/constants/app_colors.dart';
import 'package:coffe_app/view/widgets/most_ordered_card.dart';
import 'package:coffe_app/view/widgets/personal_information_card.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopSection,
              SizedBox(height: 8),
              _buildMidSection,
              SizedBox(height: 16),
              Text(
                "MOST ORDERED",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              _buildBottomSection,
              //widgetlar buraya gelecek
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget get _buildAppBar {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: EdgeInsetsGeometry.only(left: 12),
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
      ),
      title: Text(
        "Profile",
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.edit, color: Colors.black),
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
          SizedBox(height: 16),
          Text(
            "Abdullah Başpınar",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Ankara, Turkey",
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
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
        SizedBox(height: 8),
        PersonalInformationCard(
          icon_name: Icons.email_outlined,
          title: "Email Adress",
          description: "abdullahbaspinarr@gmail.com",
        ),
        SizedBox(height: 8),
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
            SizedBox(width: 8),
            MostOrderedCard(
              imagePath: "assets/product/product1.png",
              title: "Iced Latte",
              category: "Beverages",
            ),
            SizedBox(width: 8),

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
