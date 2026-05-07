import 'dart:convert';
import 'package:coffe_app/model/category.dart';
import 'package:coffe_app/model/product.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static const String _baseUrl = "https://api.escuelajs.co/api/v1";

  //kategori çekme

  Future<List<Category>> fetchCategories() async {
    final uri = Uri.parse("$_baseUrl/categories");
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception("Kategoriler alınamadı ${response.statusCode}");
    }

    final List data = jsonDecode(response.body);
    return data.map((e) => Category.fromJson(e)).toList();
  }

  //kategoriye göre ürün çekme

  Future<List<Product>> fetchProductsByCategory({
    required int categoryId,
    required int offset,
    required int limit,
  }) async {
    final uri = Uri.parse(
      "$_baseUrl/categories/$categoryId/products?offset=$offset&limit=$limit",
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception("ürünler yüklenemedei ${response.statusCode}");
    }

    final List data = jsonDecode(response.body);
    return data.map((e) => Product.fromJson(e)).toList();
  }

  // kategori içinde arama

  Future<List<Product>> searchProducts({
    required int categoryId,
    required String query,
    required int offset,
    required int limit,
  }) async {
    final uri = Uri.parse(
      "$_baseUrl/products/?title=$query&categoryId=$categoryId&offset=$offset&limit=$limit",
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception("Arama başarısız ${response.statusCode}");
    }
    final List data = jsonDecode(response.body);
    return data.map((e) => Product.fromJson(e)).toList();
  }
}
