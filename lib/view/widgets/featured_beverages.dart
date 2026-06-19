import 'package:flutter/material.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
import 'package:coffe_app/core/constants/app_colors.dart';

class FeaturedBeverageItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String points;
  final String rating;
  final VoidCallback onTap;
  final String fallbackImagePath;

  const FeaturedBeverageItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.points,
    required this.rating,
    required this.onTap,
    this.fallbackImagePath = "assets/product/product2/mocha.png",
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.border(AppRadius.size20),
                  color: AppColors.surfaceMuted,
                ),
                child: ClipRRect(
                  borderRadius: AppRadius.border(AppRadius.size20),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              fallbackImagePath,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(fallbackImagePath, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                bottom: -12,
                left: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentOrange,
                    borderRadius: AppRadius.border(AppRadius.size20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: AppColors.white, size: 16),
                      SizedBox(width: AppSpacing.s4),
                      Text(
                        rating,
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: AppTypography.bold,
                          fontSize: AppTypography.size14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: AppSpacing.s18),
          Expanded(
            child: SizedBox(
              height: 110,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppTypography.size18,
                      fontWeight: AppTypography.bold,
                      color: context.appTextPrimary,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: AppTypography.size16,
                          fontWeight: AppTypography.bold,
                          color: context.appTextPrimary,
                        ),
                      ),
                      Text(
                        points,
                        style: TextStyle(
                          fontSize: AppTypography.size16,
                          fontWeight: AppTypography.bold,
                          color: context.appPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
