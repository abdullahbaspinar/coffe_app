import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:coffe_app/core/services/product_service.dart';
import 'package:coffe_app/model/product.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductService _productService;
  ProductsCubit(this._productService) : super(const ProductsInitial());

  void fetchProducts({int? categoryId, String? query}) async {
    emit(
      ProductsLoading(
        categoryId: categoryId ?? state.categoryId,
        query: query ?? state.query,
        offset: 0,
      ),
    );

    try {
      final products = await _productService.fetchProductsByCategory(
        categoryId: state.categoryId,
        offset: state.offset,
        limit: 10,
      );

      emit(
        ProductsLoaded(
          items: products,
          hashMore: products.length >= 10,
          categoryId: state.categoryId,
          query: state.query,
          offset: state.offset + products.length,
        ),
      );
    } catch (e) {
      emit(
        ProductsError(
          errorMessage: e.toString(),
          categoryId: state.categoryId,
          query: state.query,
          offset: state.offset,
        ),
      );
    }
  }

  Future<void> loadMoreProducts() async {
    if (state is! ProductsLoaded || !(state as ProductsLoaded).hashMore) return;

    final currentState = state as ProductsLoaded;

    if (currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final newProducts = await _productService.fetchProductsByCategory(
        categoryId: currentState.categoryId,
        offset: currentState.offset,
        limit: 10,
      );

      final updatedProducts = List<Product>.from(currentState.items)
        ..addAll(newProducts);

      emit(
        ProductsLoaded(
          items: updatedProducts,
          isLoadingMore: false,
          hashMore: newProducts.length > 10,
          categoryId: currentState.categoryId,
          query: currentState.query,
          offset: currentState.offset + newProducts.length,
        ),
      );
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  Future<void> searchProducts({required String query}) async {
    if (query.isEmpty) {
      fetchProducts(categoryId: state.categoryId, query: "");
      return;
    }
    emit(
      ProductsLoading(categoryId: state.categoryId, query: query, offset: 0),
    );
    try {
      List<Product> searchResults;
      if (state.categoryId > 0) {
        searchResults = await _productService.searchProducts(
          categoryId: state.categoryId,
          query: query,
          offset: 0,
          limit: 10,
        );
      } else {
        searchResults = await _productService.searchAllProducts(
          query: query,
          offset: 0,
          limit: 10,
        );
      }
      emit(
        ProductsLoaded(
          items: searchResults,
          categoryId: state.categoryId,
          query: query,
        ),
      );
    } catch (e) {
      emit(
        ProductsError(
          errorMessage: e.toString(),
          categoryId: state.categoryId,
          query: query,
          offset: 0,
        ),
      );
    }
  }
}

/* final ProductService service;

  ProductsCubit({required this.service}) : super(const ProductsState());

  static const int _limit = 10;

  Timer? _searchDebounce;

  Future<void> init(int categoryId) async {
    emit(
      state.copyWith(
        categoryId: categoryId,
        items: [],
        offset: 0,
        hashMore: true,
        IsInitialLoading: true,
        clearError: true,
      ),
    );

    try {
      final result = await service.fetchProductsByCategory(
        categoryId: categoryId,
        offset: 0,
        limit: _limit,
      );

      emit(
        state.copyWith(
          items: result,
          offset: result.length,
          hashMore: result.length == _limit,
          IsInitialLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          IsInitialLoading: false,
        ),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hashMore || state.IsInitialLoading) return;

    emit(
      state.copyWith(
        isLoadingMore: true,
        clearError: true,
      ),
    );

    try {
      final trimmed = state.query.trim();

      final result = trimmed.isEmpty
          ? await service.fetchProductsByCategory(
              categoryId: state.categoryId,
              offset: state.offset,
              limit: _limit,
            )
          : await service.searchProducts(
              categoryId: state.categoryId,
              query: trimmed,
              offset: state.offset,
              limit: _limit,
            );

      emit(
        state.copyWith(
          items: [...state.items, ...result],
          offset: state.offset + result.length,
          hashMore: result.length == _limit,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          isLoadingMore: false,
        ),
      );
    }
  }

  void onSearchChanged(String value) {
    emit(state.copyWith(query: value));

    _searchDebounce?.cancel();
    _searchDebounce = Timer(
      const Duration(milliseconds: 350),
      _performSearch,
    );
  }

  Future<void> _performSearch() async {
    emit(
      state.copyWith(
        items: [],
        offset: 0,
        hashMore: true,
        IsInitialLoading: true,
        clearError: true,
      ),
    );

    final trimmed = state.query.trim();

    try {
      final result = trimmed.isEmpty
          ? await service.fetchProductsByCategory(
              categoryId: state.categoryId,
              offset: 0,
              limit: _limit,
            )
          : await service.searchProducts(
              categoryId: state.categoryId,
              query: trimmed,
              offset: 0,
              limit: _limit,
            );

      emit(
        state.copyWith(
          items: result,
          offset: result.length,
          hashMore: result.length == _limit,
          IsInitialLoading: false,
        ),
      );
    } catch (e) {
      try {
        final base = await service.fetchProductsByCategory(
          categoryId: state.categoryId,
          offset: 0,
          limit: 100,
        );

        final q = trimmed.toLowerCase();

        final filtered = trimmed.isEmpty
            ? base
            : base.where((p) {
                return p.title.toLowerCase().contains(q);
              }).toList();

        emit(
          state.copyWith(
            items: filtered,
            offset: filtered.length,
            hashMore : false,
            IsInitialLoading: false,
            errorMessage:
                'Backend araması başarısız',
          ),
        );
      } catch (fallbackError) {
        emit(
          state.copyWith(
            errorMessage: fallbackError.toString(),
            IsInitialLoading: false,
          ),
        );
      }
    }
  }

  Future<void> refresh() async {
    if (state.categoryId == 0) return;
    await init(state.categoryId);
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  } */
