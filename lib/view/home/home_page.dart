import 'package:coffe_app/constants/app_colors.dart';
import 'package:coffe_app/view/widgets/categories_card.dart';
import 'package:coffe_app/view/widgets/product_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class Product {
  final String imagePath;
  final String title;
  final String price;
  final String oldPrice;

  Product({
    required this.imagePath,
    required this.title,
    required this.price,
    required this.oldPrice,
  });
}

class Category {
  final String title;
  final String menu_count;
  final IconData icon_name;
  final VoidCallback onTap;

  const Category({
    required this.title,
    required this.menu_count,
    required this.icon_name,
    required this.onTap,
  });
}

class _HomePageState extends State<HomePage> {
  final List<Category> category = [
    Category(
      title: "Beverages",
      menu_count: "67",
      icon_name: Icons.coffee_outlined,
      onTap: () {},
    ),
    Category(
      title: "Foods",
      menu_count: "23",
      icon_name: Icons.food_bank_outlined,
      onTap: () {},
    ),
    Category(
      title: "Pizza",
      menu_count: "28",
      icon_name: Icons.local_pizza_outlined,
      onTap: () {},
    ),
    Category(
      title: "Drink",
      menu_count: "12",
      icon_name: Icons.local_drink_outlined,
      onTap: () {},
    ),
  ];
  final List<Product> products = [
    Product(
      imagePath: "assets/product/product1.png",
      title: "Ice Latte",
      price: "\$5.8",
      oldPrice: "\$9.9",
    ),
    Product(
      imagePath: "assets/product/product2.png",
      title: "Caramel Latte",
      price: "\$6.2",
      oldPrice: "\$8.5",
    ),
    Product(
      imagePath: "assets/product/product1.png",
      title: "Mocha Frappe",
      price: "\$7.1",
      oldPrice: "\$10.0",
    ),
    Product(
      imagePath: "assets/product/product2.png",
      title: "Mocha Frappe",
      price: "\$7.1",
      oldPrice: "\$10.0",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader,
              SizedBox(height: 12),
              _buildSearchbar,
              SizedBox(height: 12),
              _buildBody,
              SizedBox(height: 12),
              _buildCategories,
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _buildHeader {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good Morning",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            SizedBox(height: 6),
            Text(
              "Abdullah",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_bag_outlined,
                size: 28,
                color: AppColors.primaryColor,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu, size: 30, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }

  Widget get _buildSearchbar {
    return Container(
      height: 58,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: const Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
          Icon(Icons.search, color: Colors.black, size: 30),
        ],
      ),
    );
  }

  Widget get _buildBody {
    return SizedBox(
      height: 270,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ProductCard(
              imagePath: product.imagePath,
              title: product.title,
              price: product.price,
              oldPrice: product.oldPrice,
              onTap: () {
                print("product card tıklandı");
              },
            ),
          );
        },
      ),
    );
  }

  Widget get _buildCategories {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Categories",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),

        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: category.length,
            itemBuilder: (context, index) {
              final item = category[index];
              return Padding(padding: EdgeInsets.all(2),child: CategoriesCard(
                title: item.title,
                menu_count: item.menu_count,
                icon_name: item.icon_name,
                onTap: () {
                  print("categoryCard tıkladnı");
                },
              ),);
              
            },
          ),

          
        ),
      ],
    );
  }
}
