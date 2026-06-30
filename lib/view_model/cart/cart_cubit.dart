import 'package:bloc/bloc.dart';
import 'package:coffe_app/core/services/cart_service.dart';
import 'package:coffe_app/model/cart_item.dart';
import 'package:coffe_app/model/product.dart';
import 'package:coffe_app/view_model/cart/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit({CartService? cartService})
      : _cartService = cartService ?? CartService(),
        super(const CartInitial());

  final CartService _cartService;

  Future<void> loadCart() async {
    if (!_cartService.isLoggedIn) {
      emit(const CartLoaded(items: []));
      return;
    }

    emit(const CartLoading());

    try {
      final items = await _cartService.fetchCartItems();
      emit(CartLoaded(items: items));
    } catch (e) {
      emit(CartError(errorMessage: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> onUserSignedIn() => loadCart();

  void onUserSignedOut() {
    emit(const CartLoaded(items: []));
  }

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    final currentItems = _currentItems();

    final index = currentItems.indexWhere((e) => e.product.id == product.id);

    if (index >= 0) {
      currentItems[index].quantity += quantity;
    } else {
      currentItems.add(CartItem(product: product, quantity: quantity));
    }

    await _updateCart(currentItems);
  }

  Future<void> quantityPlus(Product product) async {
    if (state is! CartLoaded) return;

    final currentItems = List<CartItem>.from((state as CartLoaded).items);
    final index = currentItems.indexWhere((e) => e.product.id == product.id);

    if (index >= 0) {
      currentItems[index].quantity++;
    }

    await _updateCart(currentItems);
  }

  Future<void> quantityDecrease(Product product) async {
    if (state is! CartLoaded) return;

    final currentItems = List<CartItem>.from((state as CartLoaded).items);
    final index = currentItems.indexWhere((e) => e.product.id == product.id);

    if (index < 0) return;

    if (currentItems[index].quantity > 1) {
      currentItems[index].quantity--;
    } else {
      currentItems.removeAt(index);
    }

    await _updateCart(currentItems);
  }

  Future<void> deleteFromCart(Product product) async {
    if (state is! CartLoaded) return;

    final currentItems = List<CartItem>.from((state as CartLoaded).items)
      ..removeWhere((e) => e.product.id == product.id);

    await _updateCart(currentItems);
  }

  Future<void> clearCart() async {
    await _updateCart([]);
  }

  List<CartItem> _currentItems() {
    if (state is CartLoaded) {
      return List<CartItem>.from((state as CartLoaded).items);
    }
    return [];
  }

  Future<void> _updateCart(List<CartItem> items) async {
    emit(CartLoaded(items: items));

    if (!_cartService.isLoggedIn) return;

    try {
      await _cartService.saveCartItems(items);
    } catch (e) {
      emit(CartLoaded(items: items));
    }
  }
}
