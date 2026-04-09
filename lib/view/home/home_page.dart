import 'package:coffe_app/constants/app_colors.dart';
import 'package:coffe_app/view/widgets/product_card.dart';
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

class _HomePageState extends State<HomePage> {
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
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
