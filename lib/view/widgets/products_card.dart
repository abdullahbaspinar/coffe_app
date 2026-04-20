import 'package:flutter/material.dart';

class ProductsCard extends StatelessWidget {
 final String imagePath;
 final double rating;
 final String title;
 final String category;
 final int price;
 final VoidCallback onTap;





  const ProductsCard({super.key,
  required this.imagePath,
  required this.title,
  required this.category,
  required this.price,
  required this.rating,
  required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: SizedBox(
        width: 350,
        height: 150,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(28),

          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(imagePath),
              Column(
                children: [
                  Text(title),
                  Spacer(),
              Text(category),

                ],
              )
              
              
            ],
          ),
        ),
      ),
    );
  }
}