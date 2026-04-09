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
      appBar: _buildAppBar,
      body: _buildBody,
    );
  }

  AppBar get _buildAppBar {
    return AppBar(
      title: const Text("Anasayfa"),
    );
  }

  Widget get _buildBody {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
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
      ),
    );
  }
}