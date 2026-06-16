import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:coffe_app/model/card_item.dart';
import 'package:coffe_app/model/product.dart';
import 'package:coffe_app/view_model/cart/cart_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardCubit extends Cubit<CardState> {
  // Başlangıçta sepeti CardInitial durumunda açıyoruz
  CardCubit() : super(const CardInitial());

  static const _cardKey = "cart_items";

  Future<void> _saveCard(List<CardItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = items.map((e) => e.toJson()).toList();
    await prefs.setString(_cardKey, jsonEncode(jsonList));
  }

  Future<void> loadCard() async {
    emit(const CardLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cardKey);

      if (raw == null || raw.isEmpty) {
        emit(const CardLoaded(items: []));
        return;
      }

      final List decoded = jsonDecode(raw);
      final loadedItems = decoded
          .map((e) => CardItem.fromMap(Map<String, dynamic>.from(e)))
          .toList();
      emit(CardLoaded(items: loadedItems));
    } catch (e) {
      emit(CardError(errorMessage: e.toString()));
    }
  }

  Future<void> addToCard(Product product, {int quantity = 1}) async {
    List<CardItem> currentItems = [];

    if (state is CardLoaded) {
      currentItems = List<CardItem>.from((state as CardLoaded).items);
    }

    final index = currentItems.indexWhere((e) => e.product.id == product.id);

    if (index == 0) {
      currentItems[index].quantity += quantity;
    } else {
      currentItems.add((CardItem(product: product, quantity: quantity)));
    }

    emit(CardLoaded(items: currentItems));
    await _saveCard(currentItems);
  }

  Future<void> quantityPlus(Product product) async {
    final currentState = state as CardLoaded;
    final currentItems = List<CardItem>.from(currentState.items);

    final index = currentItems.indexWhere((e) => e.product.id == product.id);
    if (index >= 0) {
      currentItems[index].quantity++;
    }
    emit(CardLoaded(items: currentItems));
    await _saveCard(currentItems);
  }

  Future<void> quantityNotPlus(Product product) async {
    final currentState = state as CardLoaded;
    final currentItems = List<CardItem>.from(currentState.items);

    final index = currentItems.indexWhere((e) => e.product.id == product.id);

    if (index >= 0) {
      currentItems[index].quantity--;
    }
    emit(CardLoaded(items: currentItems));
    await _saveCard(currentItems);
  }

  Future<void> deleteFromCard(Product product) async {
    final currenState = state as CardLoaded;
    final currentItems = List<CardItem>.from(currenState.items);

    currentItems.removeWhere((e) => e.product.id == product.id);

    emit(CardLoaded(items: currentItems));
    await _saveCard(currentItems);
  }

  Future<void> clearCard() async {
    emit(const CardLoaded(items: []));
    await _saveCard([]);
  }

Future<void>grandTotal(Product product) async {

}

}

/* import 'dart:convert';

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
 */
