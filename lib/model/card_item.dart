import 'package:coffe_app/model/product.dart';

class CardItem {
  final Product product;
  int quantity;

  CardItem({required this.product, required this.quantity});

  double get total => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      "product": product.toJson(),
      "quantity": quantity,
    };
  }

  factory CardItem.fromMap(Map<String, dynamic> map) {
    return CardItem(
      product: Product.fromMap(Map<String, dynamic>.from(map["product"])),
      quantity: map["quantity"] ?? 1,
    );
  }
}
