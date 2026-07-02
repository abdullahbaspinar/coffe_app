import 'package:coffe_app/model/product.dart';

abstract class ProductsState {
  final List<Product> items;
  final int categoryId;
  final int offset;
  final String query;

  const ProductsState({
    this.items = const [],
    this.categoryId = 0,
    this.offset = 0,
    this.query = '',
  });
}

class ProductsInitial extends ProductsState {
  const ProductsInitial({
    super.items,
    super.categoryId,
    super.offset,
    super.query,
  });
}

class ProductsLoading extends ProductsState {
  const ProductsLoading({
    super.items,
    super.categoryId,
    super.offset,
    super.query,
  });
}

class ProductsLoaded extends ProductsState {
  final bool isLoadingMore;
  final bool hasMore;

  const ProductsLoaded({
    required super.items,
    this.isLoadingMore = false,
    this.hasMore = true,
    super.categoryId,
    super.offset,
    super.query,
  });

  ProductsLoaded copyWith({
    List<Product>? items,
    bool? isLoadingMore,
    bool? hasMore,
    int? categoryId,
    int? offset,
    String? query,
  }) {
    return ProductsLoaded(
      items: items ?? this.items,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      categoryId: categoryId ?? this.categoryId,
      offset: offset ?? this.offset,
      query: query ?? this.query,
    );
  }
}

class ProductsError extends ProductsState {
  final String errorMessage;

  const ProductsError({
    required this.errorMessage,
    super.items,
    super.categoryId,
    super.offset,
    super.query,
  });
}