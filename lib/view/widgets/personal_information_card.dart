import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_typography.dart';

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
          child: Icon(icon_name, color: context.appPrimary, size: 30),
        ),
        SizedBox(height: AppSpacing.s16),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: context.appTextPrimary,
                fontSize: AppTypography.size12,
                fontWeight: AppTypography.regular,
              ),
            ),
            SizedBox(height: AppSpacing.s6),
            Text(
              description,
              style: TextStyle(
                color: context.appTextPrimary,
                fontWeight: AppTypography.bold,
                fontSize: AppTypography.size16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
