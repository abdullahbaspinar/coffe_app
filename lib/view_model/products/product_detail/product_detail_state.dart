import 'package:coffe_app/model/product.dart';

abstract class ProductDetailState {
  const ProductDetailState();
}

class ProductDetailLoaded extends ProductDetailState {
  final Product product;
  final int quantity;
  final bool isAddingToCart;
  final bool showAddedDialog;

  const ProductDetailLoaded({
    required this.product,
    this.quantity = 1,
    this.isAddingToCart = false,
    this.showAddedDialog = false,
  });

  double get rating => product.displayRating;

  double get totalPrice => product.price * quantity;

  ProductDetailLoaded copyWith({
    Product? product,
    int? quantity,
    bool? isAddingToCart,
    bool? showAddedDialog,
  }) {
    return ProductDetailLoaded(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
      showAddedDialog: showAddedDialog ?? this.showAddedDialog,
    );
  }
}
