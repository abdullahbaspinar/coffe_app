import 'package:coffe_app/model/entity/category_entity.dart';
import 'package:coffe_app/model/entity/featured_beverage_entity.dart';
import 'package:coffe_app/model/entity/product_entity.dart';
import 'package:flutter/material.dart';

class HomeViewModel {
 
  final List<Category> categories = [
    Category(
      title: "Beverages",
      menu_count: "67",
      icon_name: Icons.coffee_outlined,
    ),
    Category(
      title: "Foods",
      menu_count: "23",
      icon_name: Icons.food_bank_outlined,
    ),
    Category(
      title: "Pizza",
      menu_count: "28",
      icon_name: Icons.local_pizza_outlined,
    ),
    Category(
      title: "Drink",
      menu_count: "12",
      icon_name: Icons.local_drink_outlined,
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

  final List<FeaturedBeverage> featuredBeverages = [
    FeaturedBeverage(
      imagePath: "assets/product/product2/tea.png",
      title: "Hot Creamy Cappuccino Latte Ombe",
      price: "\$12.6",
      points: "50",
      ratings: "3.8", 
    ),
    FeaturedBeverage(
      imagePath: "assets/product/product2/mocha.png",
      title: "Creamy Mocha Ombe Coffee",
      price: "\$12.6",
      points: "50",
      ratings: "3.8",
    ),
  ];
}
