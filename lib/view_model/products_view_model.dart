import 'dart:async';

import 'package:coffe_app/core/services/product_service.dart';
import 'package:coffe_app/model/product.dart';
import 'package:flutter/material.dart';

class ProductsViewModel extends ChangeNotifier {
  final ProductService service;

  ProductsViewModel({required this.service});

  final List<Product> _items = [];
  List<Product> get items => List.unmodifiable(_items);

  bool _isInitialLoading = false;
  bool get isInitialLoading => _isInitialLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int _categoryId = 0;
  int _offset = 0;

  static const int _limit = 10;

  String _query = '';
  String get query => _query;

  Timer? _searchDebounce;

  void _clearForFreshLoad() {
    _items.clear();
    _offset = 0;
    _hasMore = true;
  }

  Future<void> init(int categoryId) async {
    _categoryId = categoryId;
    _isInitialLoading = true;
    _errorMessage = null;
    _clearForFreshLoad();
    notifyListeners();

    try {
      final result = await service.fetchProductsByCategory(
        categoryId: _categoryId,
        offset: _offset,
        limit: _limit,
      );

      _items.addAll(result);
      _offset += result.length;
      _hasMore = result.length == _limit;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isInitialLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || _isInitialLoading) return;

    _isLoadingMore = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = _query.trim().isEmpty
          ? await service.fetchProductsByCategory(
              categoryId: _categoryId,
              offset: _offset,
              limit: _limit,
            )
          : await service.searchProducts(
              categoryId: _categoryId,
              query: _query.trim(),
              offset: _offset,
              limit: _limit,
            );

      _items.addAll(result);
      _offset += result.length;
      _hasMore = result.length == _limit;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void onSearchChanged(String value) {
    _query = value;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      _performSearch();
    });
  }

  Future<void> _performSearch() async {
    _isInitialLoading = true;
    _errorMessage = null;
    _clearForFreshLoad();
    notifyListeners();

    final trimmed = _query.trim();

    try {
      final result = trimmed.isEmpty
          ? await service.fetchProductsByCategory(
              categoryId: _categoryId,
              offset: _offset,
              limit: _limit,
            )
          : await service.searchProducts(
              categoryId: _categoryId,
              query: trimmed,
              offset: _offset,
              limit: _limit,
            );

      _items.addAll(result);
      _offset += result.length;
      _hasMore = result.length == _limit;
    } catch (e) {
      try {
        final base = await service.fetchProductsByCategory(
          categoryId: _categoryId,
          offset: 0,
          limit: 100,
        );

        final q = trimmed.toLowerCase();
        final filtered = trimmed.isEmpty
            ? base
            : base.where((p) => p.title.toLowerCase().contains(q)).toList();

        _items
          ..clear()
          ..addAll(filtered);

        _offset = _items.length;
        _hasMore = false;
        _errorMessage =
            'Backend aramasi basarisiz, local sonuclar gosteriliyor.';
      } catch (fallbackError) {
        _errorMessage = fallbackError.toString();
      }
    } finally {
      _isInitialLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    if (_categoryId == 0) return;
    await init(_categoryId);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}