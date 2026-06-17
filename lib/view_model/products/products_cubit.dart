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