import 'package:coffe_app/model/card_item.dart';

class CartState {
  final List<CardItem> items;
  final bool isLoading;
  final String? errorMessage;

  CartState({required this.items, this.isLoading = false, this.errorMessage});

  double get grandTotal {
    return items.fold(0, (sum, item) => sum + item.total);
  }

  CartState copyWith({
    List<CardItem>? items,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
