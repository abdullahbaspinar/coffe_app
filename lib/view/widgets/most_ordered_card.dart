import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_typography.dart';

class MostOrderedCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String category;

  const MostOrderedCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: context.appPrimary,
        borderRadius: AppRadius.border(AppRadius.size16),
      ),
      child: Row(
        children: [
          Image.asset(imagePath, width: 75, height: 75),
          Column(
            
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppTypography.size12,
                  fontWeight: AppTypography.bold,
                ),
              ),
              SizedBox(height: AppSpacing.s6),
              Text(
                category,
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: AppTypography.regular,
                  fontSize: AppTypography.size8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
