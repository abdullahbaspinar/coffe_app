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
    double toplam = 0.0;

    for (var item in items) {
      if (item.total != null) {
        toplam = toplam + item.total!;
      }
    }
    return toplam;
  }

  CartLoaded copyWith({List<CartItem>? items}) {
    return CartLoaded(items: items ?? this.items);
  }
}

class CartError extends CartState {
  final String errorMessage;
  const CartError({required this.errorMessage});
}

