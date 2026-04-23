import 'package:coffe_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PersonalInformationCard extends StatelessWidget {
  final IconData icon_name;
  final String title;
  final String description;

  const PersonalInformationCard({
    super.key,
    required this.icon_name,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Icon(icon_name, color: AppColors.primaryColor, size: 30),
        ),
        const SizedBox(height: 16),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 6),
            Text(
              description,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
