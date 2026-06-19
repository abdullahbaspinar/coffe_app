import 'package:flutter/material.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
import 'package:coffe_app/core/constants/app_colors.dart';

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String price;
  final String oldPrice;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 180,
        height: 270,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 70,
              left: 0,
              right: 0,
              child: Container(
                height: 180,
                padding: AppSpacing.padding16,
                decoration: BoxDecoration(
                  color: context.appPrimary,
                  borderRadius: AppRadius.border(AppRadius.size28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSpacing.s60),
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: AppTypography.size18,
                        fontWeight: AppTypography.semiBold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Row(
                      children: [
                        Text(
                          price,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: AppTypography.size24,
                            fontWeight: AppTypography.bold,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s8),
                        Text(
                          oldPrice,
                          style: TextStyle(
                            color: AppColors.textOnPrimary.withValues(alpha: 0.6),
                            fontSize: AppTypography.size16,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(imagePath, height: 150),
            ),
          ],
        ),
      ),
    );
  }
}
