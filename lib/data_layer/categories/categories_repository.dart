import 'package:e_commerce_prof/data_layer/products/products.dart';
import 'categories_web_services.dart';

class CategoriesRepository {
  final CategoriesWebServices categoriesWebServices;

  CategoriesRepository({required this.categoriesWebServices});

  Future<List<String>> getCategories() => categoriesWebServices.getCategories();

  Future<List<Products>> getProductsByCategory(String category) =>
      categoriesWebServices.getProductsByCategory(category);
}