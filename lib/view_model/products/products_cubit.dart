import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffe_app/core/services/product_service.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductService service;

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
  }
}