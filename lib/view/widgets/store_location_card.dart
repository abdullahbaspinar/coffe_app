import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
import 'package:coffe_app/model/store_location.dart';
import 'package:flutter/material.dart';

class StoreLocationCard extends StatelessWidget {
  final StoreLocation store;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onDirectionsTap;

  const StoreLocationCard({
    super.key,
    required this.store,
    required this.isSelected,
    required this.onTap,
    this.onDirectionsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.border(AppRadius.size20),
        child: Ink(
          padding: AppSpacing.padding12,
          decoration: BoxDecoration(
            color: isSelected ? context.appPrimarySurface : context.appBackground,
            borderRadius: AppRadius.border(AppRadius.size20),
            border: Border.all(
              color: isSelected ? context.appPrimary : context.appBorder.withValues(alpha: 0.5),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: context.appPrimaryTint,
                  borderRadius: AppRadius.border(AppRadius.size14),
                ),
                child: Icon(
                  Icons.storefront_rounded,
                  color: context.appPrimary,
                  size: 26,
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.appTextPrimary,
                        fontSize: AppTypography.size16,
                        fontWeight: AppTypography.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      store.adress ?? 'Adres bilgisi yok',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.appTextMuted,
                        fontSize: AppTypography.size14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (store.distanceKm != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? context.appPrimary
                            : context.appPrimaryTint,
                        borderRadius: AppRadius.border(AppRadius.size20),
                      ),
                      child: Text(
                        '${store.distanceKm!.toStringAsFixed(1)} km',
                        style: TextStyle(
                          color: isSelected ? AppColors.white : context.appPrimary,
                          fontSize: AppTypography.size12,
                          fontWeight: AppTypography.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.s8),
                  if (onDirectionsTap != null)
                    IconButton(
                      onPressed: onDirectionsTap,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      icon: Icon(
                        Icons.directions_rounded,
                        size: 22,
                        color: context.appPrimary,
                      ),
                      tooltip: 'Yol tarifi',
                    )
                  else
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: context.appPrimary,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
