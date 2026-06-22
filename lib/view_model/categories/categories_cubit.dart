import 'package:bloc/bloc.dart';
import 'package:coffe_app/core/services/product_service.dart';
import 'package:coffe_app/model/category.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final ProductService _productService;
  List<Category> _allCategories = [];

  CategoriesCubit(this._productService) : super(const CategoriesInitial());

  Future<void> fetchCategories() async {
    emit(const CategoriesLoading());

    try {
      _allCategories = await _productService.fetchCategories();
      emit(CategoriesLoaded(categories: _allCategories));
    } catch (e) {
      emit(CategoriesError(errorMessage: e.toString()));
    }
  }

  void searchCategories(String query) {
    if (_allCategories.isEmpty) return; // henüz yüklenmediyse arama yapma
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) {
      emit(CategoriesLoaded(categories: _allCategories));
      return;
    }
    final filtered = _allCategories
        .where((category) => category.name.toLowerCase().contains(trimmed))
        .toList();
    emit(CategoriesLoaded(categories: filtered, query: query));
  }
}
