import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/view_model/cart/cart_cubit.dart';
import 'package:coffe_app/view_model/cart/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompleteOrdersButton extends StatelessWidget {
  const CompleteOrdersButton({super.key});

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.border(AppRadius.size24),
          ),
          child: Stack(
            children: [
              Padding(
                padding: AppSpacing.padding24,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: AppSpacing.s16),

                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: context.appPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: AppColors.white,
                        size: 48,
                      ),
                    ),

                    SizedBox(height: AppSpacing.s20),

                    Text(
                      "Order Completed",
                      style: TextStyle(
                        fontSize: AppTypography.size22,
                        fontWeight: AppTypography.bold,
                      ),
                    ),

                    SizedBox(height: AppSpacing.s8),

                    Text(
                      "Your order has been successfully placed.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: context.appTextMuted),
                    ),
                  ],
                ),
              ),

              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.appPrimary,
      borderRadius: AppRadius.border(AppRadius.size16),
      child: InkWell(
        onTap: () async {
          final state = context.read<CartCubit>().state;
          if (state is! CartLoaded || state.items.isEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Sepetiniz boş.')));
            return;
          }
          await context.read<CartCubit>().clearCart();
          if (!context.mounted) return;
          _showSuccessDialog(context);
        },
        borderRadius: AppRadius.border(AppRadius.size16),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text(
              "Complete Order",
              style: TextStyle(
                fontSize: AppTypography.size16,
                color: AppColors.white,
                fontWeight: AppTypography.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
