import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:coffe_app/model/card_item.dart';
import 'package:coffe_app/model/product.dart';
import 'package:coffe_app/view_model/cart/cart_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState(items: []));

  static const _cartKey = "cart_items";

  Future<void> _saveCart(List<CardItem> items) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList = items.map((e) => e.toJson()).toList();

    await prefs.setString(_cartKey, jsonEncode(jsonList));
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getString(_cartKey);

    if (raw == null || raw.isEmpty) {
      emit(state.copyWith(items: []));
      return;
    }

    final List decoded = jsonDecode(raw);

    final loadedItems = decoded
        .map((e) => CardItem.fromMap(Map<String, dynamic>.from(e)))
        .toList();

    emit(state.copyWith(items: loadedItems));
  }

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    final currentItems = List<CardItem>.from(state.items);

    final index = currentItems.indexWhere((e) => e.product.id == product.id);

    if (index >= 0) {
      currentItems[index].quantity += quantity;
    } else {
      currentItems.add(CardItem(product: product, quantity: quantity));
    }

    emit(state.copyWith(items: currentItems));

    await _saveCart(currentItems);
  }

  Future<void> increaseQuantity(Product product) async {
    final currentItems = List<CardItem>.from(state.items);

    final index = currentItems.indexWhere((e) => e.product.id == product.id);

    if (index < 0) return;

    currentItems[index].quantity++;

    emit(state.copyWith(items: currentItems));

    await _saveCart(currentItems);
  }

  Future<void> decreaseQuantity(Product product) async {
    final currentItems = List<CardItem>.from(state.items);

    final index = currentItems.indexWhere((e) => e.product.id == product.id);

    if (index < 0) return;

    if (currentItems[index].quantity > 1) {
      currentItems[index].quantity--;
    } else {
      currentItems.removeAt(index);
    }

    emit(state.copyWith(items: currentItems));

    await _saveCart(currentItems);
  }

  Future<void> removeFromCart(Product product) async {
    final currentItems = List<CardItem>.from(state.items);

    currentItems.removeWhere((e) => e.product.id == product.id);

    emit(state.copyWith(items: currentItems));

    await _saveCart(currentItems);
  }

  Future<void> clearCart() async {
    emit(state.copyWith(items: []));

    await _saveCart([]);
  }
}
