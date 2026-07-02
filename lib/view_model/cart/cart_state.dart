import 'package:coffe_app/model/cart_item.dart';


abstract class CartState {
  const CartState();

}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  final List<CartItem> items;

  const CartLoaded({required this.items});

  double get grandTotal {
    return items.fold(0.0, (sum, item) => sum + item.total);
  }

  CartLoaded copyWith({List<CartItem>? items}) {
    return CartLoaded(items: items ?? this.items);
  }
}

class CartError extends CartState {
  final String errorMessage;
  const CartError({required this.errorMessage});
}

