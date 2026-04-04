import 'package:e_commerce_prof/data_layer/helper/dio_helper.dart';
import 'package:e_commerce_prof/data_layer/products/products.dart';

import '../../networks/end_points.dart';

class ProductsWebServices {
  Future<List<Products>> getAllProducts() async {
    final response = await DioHelper_Products.getData_products(url: PRODUCTS);
    return (response.data['products'] as List)
        .map((e) => Products.fromJson(e))
        .toList();
  }

  Future<Products> getSingleProduct(int id) async {
    final response = await DioHelper_Products.getData_products(url: singleProductPath(id));
    return Products.fromJson(response.data); // ✅ object واحد
  }

  Future<List<dynamic>> getProductsSorted({
    required String sortBy,
    required String order,
  }) async {
    final response= await DioHelper_Products.getData_products(url: PRODUCTS,query: {
      "sortBy":sortBy,
      "order":order,
    });
    return response.data['products'];

  }
  Future<List<dynamic>> searchProducts(String query) async {
    final response = await DioHelper_Products.getData_products(url: PRODUCTS_SEARCH, query: {
      "q": query,
    });
    return response.data['products'];
  }
  Future<Products> addProduct(Products product) async {
  final response= await DioHelper_Products.postData_products(url: PRODUCTS_ADD,data: product.toJson());
  return Products.fromJson(response.data);
  }
}
