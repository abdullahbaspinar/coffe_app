import 'package:coffe_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class OrdersCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final double price;
  final int count;
  final VoidCallback onTap;

  const OrdersCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material( 
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap, 
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "\$ $price",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "$count x",
                    style:
                        const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${(price * count).toStringAsFixed(1)}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryColor,
                    ),
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