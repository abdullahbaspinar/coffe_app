import 'package:coffe_app/model/product.dart';

class ProductsState {
  final List<Product> items;
  final bool IsInitialLoading;
  final bool isLoadingMore;
  final bool hashMore;
  final String? errorMessage;
  final int categoryId;
  final int offset;
  final String query;

  const ProductsState({
    this.items = const [],
    this.IsInitialLoading = false,
    this.isLoadingMore = false,
    this.hashMore = true,
    this.errorMessage,
    this.categoryId = 0,
    this.offset = 0,
    this.query = "",
  });

  ProductsState copyWith({
    List<Product>? items,
    bool? IsInitialLoading,
    bool? isLoadingMore,
    bool? hashMore,
    String? errorMessage,
    bool clearError = false,
    int? categoryId,
    int? offset,
    String? query,
  }) {
    return ProductsState(
      items: items ?? this.items,
      IsInitialLoading: IsInitialLoading ?? this.IsInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hashMore: hashMore ?? this.hashMore,
      errorMessage: errorMessage ?? this.errorMessage,
      categoryId: categoryId ?? this.categoryId,
      offset: offset ?? this.offset,
      query: query ?? this.query,
    );
  }
}
