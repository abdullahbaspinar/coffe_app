import 'package:coffe_app/model/category.dart';

abstract class CategoriesState {
  const CategoriesState();
}

class CategoriesInitial extends CategoriesState {
  const CategoriesInitial();
}

class CategoriesLoading extends CategoriesState {
  const CategoriesLoading();
}

class CategoriesLoaded extends CategoriesState {
  final List<Category> categories;
  final String query;

  const CategoriesLoaded({
    required this.categories,
    this.query = '',
  });
}

class CategoriesError extends CategoriesState {
  final String errorMessage;

  const CategoriesError({required this.errorMessage});
}