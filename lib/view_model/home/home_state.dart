import 'package:coffe_app/model/category.dart';
import 'package:coffe_app/model/product.dart';

abstract class HomeState {
  final List<Category> categories;
  final String searchQuery;
  final List<Product> searchResults;
  final List<Product> featuredProducts;

  const HomeState({
    this.categories = const [],
    this.searchQuery = '',
    this.searchResults = const [],
    this.featuredProducts = const [],
  });
}

class HomeInitial extends HomeState {
  const HomeInitial({
    super.categories,
    super.searchQuery,
    super.searchResults,
    super.featuredProducts,
  });
}

class HomeLoading extends HomeState {
  const HomeLoading({
    super.categories,
    super.searchQuery,
    super.searchResults,
    super.featuredProducts,
  });
}

class HomeLoaded extends HomeState {
  final List<Category> categories;
  final List<Product> featuredProducts;
  final bool isSearchLoading;
  final String? searchError;

  const HomeLoaded({
    required this.categories,
    required this.featuredProducts,
    this.isSearchLoading = false,
    this.searchError,
    super.searchQuery,
    super.searchResults,
  });

  HomeLoaded copyWith({
    List<Category>? categories,
    List<Product>? featuredProducts,
    bool? isSearchLoading,
    String? searchError,
    bool clearSearchError = false,
    String? searchQuery,
    List<Product>? searchResults,
  }) {
    return HomeLoaded(
      categories: categories ?? this.categories,
      featuredProducts: featuredProducts ?? this.featuredProducts,
      isSearchLoading: isSearchLoading ?? this.isSearchLoading,
      searchError: clearSearchError ? null : (searchError ?? this.searchError),
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
    );
  }
}

class HomeError extends HomeState {
  final String errorMessage;

  const HomeError({
    required this.errorMessage,
    super.categories,
    super.searchQuery,
    super.searchResults,
    super.featuredProducts,
  });
}
