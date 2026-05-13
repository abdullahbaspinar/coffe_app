import 'package:coffe_app/constants/app_colors.dart';
import 'package:coffe_app/view_model/card_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TotalAmount extends StatelessWidget {
  final double? amount;
  final String title;

  const TotalAmount({super.key, this.amount, this.title = "Total Amount"});

  @override
  Widget build(BuildContext context) {
    final total = amount ?? context.watch<CardViewModel>().grandTotal;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            "\$${total.toStringAsFixed(1)}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
