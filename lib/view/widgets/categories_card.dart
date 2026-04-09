import 'package:coffe_app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CategoriesCard extends StatelessWidget {
  final String title;
  final String menu_count;
  final IconData icon_name;
  final VoidCallback onTap;

  const CategoriesCard({
    super.key,
    required this.title,
    required this.menu_count,
    required this.icon_name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),

        width: 170,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          
          children: [
            Icon(icon_name, color: AppColors.primaryColor),

            Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("$menu_count Menus",style: TextStyle(
                  color: AppColors.primaryColor
                ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
