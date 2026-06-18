import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.transparent,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            const SizedBox(width: 16),
            Expanded(child: _buildRightSection()),
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
            borderRadius: BorderRadius.circular(24),
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
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: AppColors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRightSection() {
    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          // Yazılar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(category, style: const TextStyle(color: AppColors.textMuted)),
              const Spacer(),
              Text(
                "\$${price.toStringAsFixed(1)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
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
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: AppColors.primaryDark,
                    size: 20,
                  ),
                  SizedBox(width: 6),
                  Text(
                    "Buy",
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
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
