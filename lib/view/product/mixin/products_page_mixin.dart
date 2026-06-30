import 'package:coffe_app/core/router/app_router.dart';
import 'package:coffe_app/core/services/product_service.dart';
import 'package:coffe_app/model/category.dart';
import 'package:coffe_app/model/product.dart';
import 'package:coffe_app/view/product/products.dart';
import 'package:coffe_app/view_model/products/products_cubit.dart';
import 'package:flutter/material.dart';

mixin ProductsPageMixin on State<Products> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  late final ProductsCubit productsCubit;

  Category get category => widget.category;

  @override
  void initState() {
    super.initState();
    productsCubit = ProductsCubit(ProductService());
    productsCubit.fetchProducts(categoryId: category.id);
    scrollController.addListener(onScroll);
  }

  void onScroll() {
    if (!scrollController.hasClients) return;
    final threshold = scrollController.position.maxScrollExtent - 200;
    if (scrollController.position.pixels >= threshold) {
      productsCubit.loadMoreProducts();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    productsCubit.close();
    super.dispose();
  }

  Future<void> refreshProducts() async {
    productsCubit.fetchProducts(categoryId: category.id);
  }

  void onSearchChanged(String value) {
    productsCubit.searchProducts(query: value);
  }

  void openProductDetail(Product product) {
    AppRouter.openProductDetail(product);
  }

  void closePage() {
    AppRouter.pop();
  }
}
