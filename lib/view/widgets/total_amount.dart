import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/view_model/cart/cart_cubit.dart';
import 'package:coffe_app/view_model/cart/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_typography.dart';

class TotalAmount extends StatelessWidget {
  final String title;

  const TotalAmount({super.key, this.title = "Total Amount"});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CartCubit>().state;

    double finalTotal = 0.0;
    if (state is CartLoaded) {
      finalTotal = state.grandTotal;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: context.appSecondary,
        borderRadius: AppRadius.border(AppRadius.size18),
        border: Border.all(color: context.appBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: context.appPrimaryTint,
              borderRadius: AppRadius.border(AppRadius.size12),
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              color: context.appPrimary,
            ),
          ),
          SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: AppTypography.size16,
                fontWeight: AppTypography.semiBold,
                color: context.appTextPrimary,
              ),
            ),
          ),
          Text(
            "\$${finalTotal.toStringAsFixed(1)}",
            style: TextStyle(
              fontSize: AppTypography.size20,
              fontWeight: AppTypography.extraBold,
              color: context.appPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
