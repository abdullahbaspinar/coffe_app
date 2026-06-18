import 'dart:collection';

import 'package:coffe_app/core/services/product_service.dart';
import 'package:coffe_app/model/product.dart';
import 'package:coffe_app/view/product/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class ProductsState {
    final List<Product> items;
  final int categoryId;
  final int offset;
  final String query;

  const ProductsState({this.categoryId = 0, this.offset = 0, this.query = "",this.items=const []});
}

class ProductsInitial extends ProductsState {
  const ProductsInitial({super.categoryId, super.offset, super.query, super.items});
}

class ProductsLoading extends ProductsState {
  const ProductsLoading({super.categoryId, super.offset, super.query, super.items});
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
