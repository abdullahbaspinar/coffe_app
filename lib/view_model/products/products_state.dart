import 'dart:collection';

import 'package:coffe_app/core/services/product_service.dart';
import 'package:coffe_app/model/product.dart';
import 'package:coffe_app/view/product/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class ProductsState {
  final int categoryId;
  final int offset;
  final String query;

  const ProductsState({this.categoryId = 0, this.offset = 0, this.query = ""});
}

class ProductsInitial extends ProductsState {
  const ProductsInitial({super.categoryId, super.offset, super.query});
}

class ProductsLoading extends ProductsState {
  const ProductsLoading({super.categoryId, super.offset, super.query});
}



class ProductsLoaded extends ProductsState {
  final List<Product> items;
  final bool isLoadingMore;
  final bool hashMore;

  const ProductsLoaded({
    required this.items,
    this.isLoadingMore = false,
    this.hashMore = true,
    super.categoryId,
    super.offset,
    super.query,
  });

  ProductsLoaded copyWith({
    List<Product>? items,
    bool? isLoadingMore,
    bool? hashMore,
    int? categoryId,
    int? offset,
    String? query,
  }) {
    return ProductsLoaded(
      items: items ?? this.items,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hashMore: hashMore ?? this.hashMore,
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
    super.categoryId,
    super.offset,
    super.query,
  });
}



/* class ProductsState {
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
 */