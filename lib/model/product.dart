class Product {
  final int id;
  final String title;
  final String description;
  final int categoryId;
  final String category;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
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
      categoryId: json["category"]?["id"] ?? 0,
      category: json["category"]?["name"] ?? "",
      price: (json["price"] as num?)?.toDouble() ?? 0.0,
      imageUrl: (images != null && images.isNotEmpty && images.first is String)
          ? images.first as String
          : "",
    );
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map["id"] ?? 0,
      title: map["title"] ?? "",
      description: map["description"] ?? "",
      categoryId: map["categoryId"] ?? 0,
      category: map["category"] ?? "",
      price: (map["price"] as num?)?.toDouble() ?? 0.0,
      imageUrl: map["imageUrl"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "categoryId":categoryId,
      "category": category,
      "price": price,
      "imageUrl": imageUrl,
    };
  }
}
