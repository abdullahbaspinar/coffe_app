import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:coffe_app/model/cart_item.dart';
import 'package:coffe_app/model/product.dart';
import 'package:coffe_app/view_model/cart/cart_state.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CartCubit extends Cubit<CartState> {
  // Başlangıçta sepeti CartInitial durumunda açıyoruz
  CartCubit() : super(const CartInitial());

  static const _CartKey = "cart_items";

  Future<void> _saveCart(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = items.map((e) => e.toJson()).toList();
    await prefs.setString(_CartKey, jsonEncode(jsonList));
  }

  Future<void> loadCart() async {
    emit(const CartLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_CartKey);

      if (raw == null || raw.isEmpty) {
        emit(const CartLoaded(items: []));
        return;
      }

      final List decoded = jsonDecode(raw);
      final loadedItems = decoded
          .map((e) => CartItem.fromMap(Map<String, dynamic>.from(e)))
          .toList();
      emit(CartLoaded(items: loadedItems));
    } catch (e) {
      emit(CartError(errorMessage: e.toString()));
    }
  }

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    List<CartItem> currentItems = [];

    if (state is CartLoaded) {
      currentItems = List<CartItem>.from((state as CartLoaded).items);
    }

    final index = currentItems.indexWhere((e) => e.product.id == product.id);

    if (index >= 0) {
      currentItems[index].quantity += quantity;
    } else {
      currentItems.add((CartItem(product: product, quantity: quantity)));
    }

    emit(CartLoaded(items: currentItems));
    await _saveCart(currentItems);
  }

  Future<void> quantityPlus(Product product) async {
    final currentState = state as CartLoaded;
    final currentItems = List<CartItem>.from(currentState.items);

    final index = currentItems.indexWhere((e) => e.product.id == product.id);
    if (index >= 0) {
      currentItems[index].quantity++;
    }
    emit(CartLoaded(items: currentItems));
    await _saveCart(currentItems);
  }

  Future<void> quantityDecrease(Product product) async {
    final currentState = state as CartLoaded;
    final currentItems = List<CartItem>.from(currentState.items);

    final index = currentItems.indexWhere((e) => e.product.id == product.id);

    if (index < 0) {
      return;
    }
    if (currentItems[index].quantity > 1) {
      currentItems[index].quantity--;
    } else {
      currentItems.removeAt(index);
    }
    emit(CartLoaded(items: currentItems));
    await _saveCart(currentItems);
  }

  Future<void> deleteFromCart(Product product) async {
    final currenState = state as CartLoaded;
    final currentItems = List<CartItem>.from(currenState.items);

    currentItems.removeWhere((e) => e.product.id == product.id);

    emit(CartLoaded(items: currentItems));
    await _saveCart(currentItems);
  }

  Future<void> clearCart() async {
    emit(const CartLoaded(items: []));
    await _saveCart([]);
  }
}
