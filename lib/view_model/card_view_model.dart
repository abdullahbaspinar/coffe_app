import 'dart:convert';

import 'package:coffe_app/model/card_item.dart';
import 'package:coffe_app/model/product.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardViewModel extends ChangeNotifier {
  static const _cartKey = "cart_items";
  final List<CardItem> _items = [];
  List<CardItem> get items => List.unmodifiable(_items);

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _items.map((e) => e.toJson()).toList();
    await prefs.setString(_cartKey, jsonEncode(jsonList));
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cartKey);
    if (raw == null || raw.isEmpty) return;

    final List decoded = jsonDecode(raw);
    _items
      ..clear()
      ..addAll(
        decoded.map((e) => CardItem.fromMap(Map<String, dynamic>.from(e))),
      );
    notifyListeners();
  }

  Future<void> addToCard(Product product, {int quantity = 1}) async {
    final index = _items.indexWhere((e) => e.product.id == product.id);

    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CardItem(product: product, quantity: quantity));
    }
    notifyListeners();
    await _saveCart();
  }

  Future<void> clearCart() async {
    _items.clear();
    notifyListeners();
    await _saveCart();
  }

  double get grandTotal => _items.fold(0, (sum, item) => sum + item.total);
}
