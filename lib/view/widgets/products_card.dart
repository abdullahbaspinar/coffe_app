import 'package:flutter/material.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
import 'package:coffe_app/core/constants/app_colors.dart';

class ProductsCard extends StatelessWidget {
  final String imagePath;
  final String imageUrl;
  final double rating;
  final String title;
  final String category;
  final double price;
  final VoidCallback onTap;

  const ProductsCard({
    super.key,
    required this.imagePath,
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.padding16,
        decoration: BoxDecoration(
          color: AppColors.transparent,
          borderRadius: AppRadius.border(AppRadius.size28),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            const SizedBox(width: AppSpacing.s16),
            Expanded(child: _buildRightSection(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    final ImageProvider imageProvider = imageUrl.isNotEmpty
        ? NetworkImage(imageUrl)
        : AssetImage(imagePath);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            borderRadius: AppRadius.border(AppRadius.size24),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),

        Positioned(
          bottom: -12,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.accentOrange,
              borderRadius: AppRadius.border(AppRadius.size22),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: AppColors.white, size: 16),
                const SizedBox(width: AppSpacing.s6),
                Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: AppTypography.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRightSection(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppTypography.size18,
                  fontWeight: AppTypography.bold,
                ),
              ),
              SizedBox(height: AppSpacing.s6),
              Text(category, style: TextStyle(color: context.appTextMuted)),
              const Spacer(),
              Text(
                "\$${price.toStringAsFixed(1)}",
                style: TextStyle(
                  fontSize: AppTypography.size20,
                  fontWeight: AppTypography.extraBold,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: context.appPrimarySurface,
                borderRadius: AppRadius.border(AppRadius.size24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: context.appPrimary,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.s6),
                  Text(
                    "Buy",
                    style: TextStyle(
                      color: context.appPrimary,
                      fontWeight: AppTypography.bold,
                    ),
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
