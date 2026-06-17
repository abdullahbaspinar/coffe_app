import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffe_app/core/services/product_service.dart';
import 'package:coffe_app/model/category.dart';
import 'package:coffe_app/model/product.dart';
import 'package:coffe_app/view_model/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ProductService _productService;
  Timer? _searchDebounce;

  HomeCubit({ProductService? productService})
      : _productService = productService ?? ProductService(),
        super(const HomeInitial());

  Future<void> loadHomeData() async {
    emit(
      HomeLoading(
        categories: state.categories,
        searchQuery: state.searchQuery,
        searchResults: state.searchResults,
        featuredProducts: state.featuredProducts,
      ),
    );

    try {
      final results = await Future.wait([
        _productService.fetchCategories(),
        _productService.fetchProducts(offset: 0, limit: 2),
      ]);

      final categories = results[0] as List<Category>;
      final featured = results[1] as List<Product>;

      emit(
        HomeLoaded(
          categories: categories.take(8).toList(),
          featuredProducts: featured,
          searchQuery: state.searchQuery,
          searchResults: state.searchResults,
        ),
      );
    } catch (e) {
      emit(
        HomeError(
          errorMessage: e.toString(),
          searchQuery: state.searchQuery,
          searchResults: state.searchResults,
          featuredProducts: state.featuredProducts,
        ),
      );
    }
  }

  void onSearchChanged(String value) {
    final trimmed = value.trim();

    _emitLoadedUpdate(
      searchQuery: value,
      isSearchLoading: trimmed.isNotEmpty,
      searchResults: trimmed.isEmpty ? [] : null,
      clearSearchError: true,
    );

    _searchDebounce?.cancel();
    _searchDebounce = Timer(
      const Duration(milliseconds: 350),
      () => _performSearch(trimmed),
    );
  }

  Future<void> _performSearch(String trimmed) async {
    if (trimmed.isEmpty) {
      _emitLoadedUpdate(
        searchResults: [],
        isSearchLoading: false,
        clearSearchError: true,
      );
      return;
    }

    _emitLoadedUpdate(
      isSearchLoading: true,
      clearSearchError: true,
    );

    try {
      final results = await _productService.searchAllProducts(
        query: trimmed,
        offset: 0,
        limit: 20,
      );

      if (trimmed != state.searchQuery.trim()) return;

      _emitLoadedUpdate(
        searchResults: results,
        isSearchLoading: false,
      );
    } catch (e) {
      if (trimmed != state.searchQuery.trim()) return;

      _emitLoadedUpdate(
        isSearchLoading: false,
        searchError: e.toString(),
      );
    }
  }

  void clearSearch() {
    _searchDebounce?.cancel();
    _emitLoadedUpdate(
      searchQuery: '',
      searchResults: [],
      isSearchLoading: false,
      clearSearchError: true,
    );
  }

  void _emitLoadedUpdate({
    List<Category>? categories,
    List<Product>? featuredProducts,
    bool? isSearchLoading,
    String? searchError,
    bool clearSearchError = false,
    String? searchQuery,
    List<Product>? searchResults,
  }) {
    final current = state;

    if (current is HomeLoaded) {
      emit(
        current.copyWith(
          categories: categories,
          featuredProducts: featuredProducts,
          isSearchLoading: isSearchLoading,
          searchError: searchError,
          clearSearchError: clearSearchError,
          searchQuery: searchQuery,
          searchResults: searchResults,
        ),
      );
      return;
    }

    emit(
      HomeLoaded(
        categories: categories ?? current.categories,
        featuredProducts: featuredProducts ?? current.featuredProducts,
        isSearchLoading: isSearchLoading ?? false,
        searchError: clearSearchError ? null : searchError,
        searchQuery: searchQuery ?? current.searchQuery,
        searchResults: searchResults ?? current.searchResults,
      ),
    );
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
