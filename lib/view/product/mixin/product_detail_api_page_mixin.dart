import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
import 'package:coffe_app/model/product.dart';
import 'package:coffe_app/view/product/product_detail_page_api.dart';
import 'package:coffe_app/view_model/cart/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin ProductDetailApiPageMixin on State<ProductDetailPageApi> {
  int quantity = 1;

  Product get product => widget.product;

  double get rating => product.displayRating;

  void incrementQuantity() {
    setState(() => quantity++);
  }

  void decrementQuantity() {
    if (quantity > 0) {
      setState(() => quantity--);
    }
  }

  Future<void> addToCart() async {
    await context.read<CartCubit>().addToCart(
          product,
          quantity: quantity,
        );

    if (!mounted) return;
    showAddedToCartDialog();
  }

  void showAddedToCartDialog() {
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
