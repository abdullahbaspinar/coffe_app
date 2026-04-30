import 'package:coffe_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MostOrderedCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String category;

  const MostOrderedCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Image.asset(imagePath, width: 75, height: 75),
          Column(
            
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                category,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
