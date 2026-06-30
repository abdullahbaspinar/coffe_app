import 'package:coffe_app/core/router/app_router.dart';
import 'package:coffe_app/core/services/product_service.dart';
import 'package:coffe_app/model/category.dart';
import 'package:coffe_app/view/categories/all_categories.dart';
import 'package:coffe_app/view_model/categories/categories_cubit.dart';
import 'package:flutter/material.dart';

mixin AllCategoriesPageMixin on State<AllCategories> {
  final TextEditingController searchController = TextEditingController();
  final CategoriesCubit categoriesCubit = CategoriesCubit(ProductService());

  @override
  void initState() {
    super.initState();
    categoriesCubit.fetchCategories();
  }

  @override
  void dispose() {
    searchController.dispose();
    categoriesCubit.close();
    super.dispose();
  }

  void openCategory(Category category) {
    AppRouter.openProductsByCategory(category);
  }

  void onSearchChanged(String value) {
    categoriesCubit.searchCategories(value);
  }

  void closePage() {
    AppRouter.pop();
  }
}
