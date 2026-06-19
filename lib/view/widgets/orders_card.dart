import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_typography.dart';

class OrdersCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final double price;
  final int count;
  final VoidCallback onTap;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onDelete;

  const OrdersCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.count,
    required this.onTap,
    required this.onIncrease,
    required this.onDecrease,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('$title-$imagePath'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.errorAccent,
          borderRadius: AppRadius.border(AppRadius.size12),
        ),
        child: Icon(Icons.delete_outline, color: AppColors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.border(AppRadius.size12),
          child: Container(
            padding: AppSpacing.padding12,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: AppRadius.border(AppRadius.size12),
                  child: Image.network(
                    imagePath,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: AppSpacing.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: AppTypography.size16,
                          fontWeight: AppTypography.semiBold,
                        ),
                      ),
                      SizedBox(height: AppSpacing.s8),
                      Text(
                        "\$ $price",
                        style: TextStyle(
                          fontSize: AppTypography.size14,
                          color: context.appTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: onDelete,
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.errorAccent,
                      ),
                    ),
                    Text(
                      "\$${(price * count).toStringAsFixed(1)}",
                      style: TextStyle(
                        fontSize: AppTypography.size14,
                        color: context.appPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _QuantityButton(icon: Icons.remove, onTap: onDecrease),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "$count",
                            style: const TextStyle(
                              fontSize: AppTypography.size14,
                              fontWeight: AppTypography.bold,
                            ),
                          ),
                        ),
                        _QuantityButton(icon: Icons.add, onTap: onIncrease),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.border(AppRadius.size8),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: context.appPrimary,
          borderRadius: AppRadius.border(AppRadius.size8),
        ),
        child: Icon(icon, color: AppColors.white, size: 16),
      ),
    );
  }
}
