import 'package:flutter/material.dart';

class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final images = json["images"] as List?;

    return Product(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      category: json["category"]?["name"] ?? "",
      price: (json["price"] as num?)?.toDouble() ?? 0.0,
      imageUrl: (images != null && images.isNotEmpty && images.first is String)
          ? images.first as String
          : "",
    );
  }
}
