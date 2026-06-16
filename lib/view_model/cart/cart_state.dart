import 'package:coffe_app/model/card_item.dart';

abstract class CardState {
  const CardState();

  get items => null;
}

class CardInitial extends CardState {
  const CardInitial();
}

class CardLoading extends CardState {
  const CardLoading();
}

class CardLoaded extends CardState {
  final List<CardItem> items;

  const CardLoaded({required this.items});

  double get grandTotal {
    double toplam = 0.0;

    for (var item in items) {
      if (item.total != null) {
        toplam = toplam + item.total!;
      }
    }
    return toplam;
  }

  CardLoaded copyWith({List<CardItem>? items}) {
    return CardLoaded(items: items ?? this.items);
  }
}

class CardError extends CardState {
  final String errorMessage;
  const CardError({required this.errorMessage});
}

/* class CartState {
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
} */
