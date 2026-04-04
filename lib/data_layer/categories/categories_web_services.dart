import '../../networks/end_points.dart';
import '../helper/dio_helper.dart';
import '../products/products.dart';

class CategoriesWebServices {
  Future<List<String>> getCategories() async {
    final res = await DioHelper_Products.getData_products(url: PRODUCTS_CATEGORIES);

    final data = res.data;

      if (data.isNotEmpty && data.first is Map) {
        return (res.data as List)
            .map((e) => e['slug'].toString())
            .toList();
    }

    throw Exception("Unexpected categories response: ${data.runtimeType}");
  }
  Future<List<Products>> getProductsByCategory(String category) async {

    final response = await DioHelper_Products.getData_products(url: productsByCategoryPath(category));
    print(response.data.runtimeType);
    print(response.data);
    return (response.data['products'] as List)
        .map((e) => Products.fromJson(e))
        .toList();

  }
}