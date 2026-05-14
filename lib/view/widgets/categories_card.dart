import 'package:coffe_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CategoriesCard extends StatelessWidget {
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
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildLeadingImage(),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (menuCount != null && menuCount!.trim().isNotEmpty)
                    Text(
                      '$menuCount Menus',
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 12,
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

  Widget _buildLeadingImage() {
    if (imageUrl != null && imageUrl!.trim().isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl!,
          width: 38,
          height: 38,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallbackIcon(),
        ),
      );
    }
    return _fallbackIcon();
  }

  Widget _fallbackIcon() {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.category_outlined,
        color: AppColors.primaryColor,
        size: 20,
      ),
    );
  }
}