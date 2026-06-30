import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_typography.dart';

class CategoriesCard extends StatelessWidget {
  static const String fallbackImagePath = 'assets/image_coming_soon.png';

  final String title;
  final String? menuCount;
  final String? imageUrl;
  final VoidCallback onTap;

  const CategoriesCard({
    super.key,
    required this.title,
    required this.onTap,
    this.menuCount,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 190,
        height: 62,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: context.appBackground,
          borderRadius: AppRadius.border(AppRadius.size20),
          border: Border.all(color: context.appBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildLeadingImage(context),
            SizedBox(width: AppSpacing.s10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: context.appTextPrimary,
                      fontWeight: AppTypography.bold,
                    ),
                  ),
                  if (menuCount != null && menuCount!.trim().isNotEmpty)
                    Text(
                      '$menuCount Menus',
                      style: TextStyle(
                        color: context.appPrimary,
                        fontSize: AppTypography.size12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingImage(BuildContext context) {
    if (imageUrl != null && imageUrl!.trim().isNotEmpty) {
      return ClipRRect(
        borderRadius: AppRadius.border(AppRadius.size10),
        child: Image.network(
          imageUrl!,
          width: 38,
          height: 38,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallbackImage(),
        ),
      );
    }
    return _fallbackImage();
  }

  Widget _fallbackImage() {
    return ClipRRect(
      borderRadius: AppRadius.border(AppRadius.size10),
      child: Image.asset(
        fallbackImagePath,
        width: 38,
        height: 38,
        fit: BoxFit.cover,
      ),
    );
  }
}