import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
import 'package:coffe_app/core/router/app_router.dart';
import 'package:coffe_app/model/product.dart';
import 'package:coffe_app/view/product/product_detail_page_api.dart';
import 'package:flutter/material.dart';

mixin ProductDetailApiPageMixin on State<ProductDetailPageApi> {
  void closePage() {
    AppRouter.pop();
  }

  void showAddedToCartDialog(Product product) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.border(AppRadius.size24),
          ),
          child: Padding(
            padding: AppSpacing.padding24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: context.appPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColors.white,
                    size: 42,
                  ),
                ),
                const SizedBox(height: AppSpacing.s18),
                const Text(
                  'Successfully Added to Cart',
                  style: TextStyle(
                    fontSize: AppTypography.size22,
                    fontWeight: AppTypography.extraBold,
                  ),
                ),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  '${product.title} successfully added to cart.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppTypography.size14,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: AppSpacing.s18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.appPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.border(AppRadius.size16),
                      ),
                      elevation: 0,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: AppTypography.size16,
                          fontWeight: AppTypography.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
