import 'package:e_commerce_prof/data_layer/products/products.dart';
import 'package:e_commerce_prof/data_layer/products/products_web_services.dart';

class ProductsRepository {
  final ProductsWebServices productsWebServices;

  ProductsRepository({required this.productsWebServices});

  Future<List<Products>> getAllProducts() async {
    return await productsWebServices.getAllProducts();
  }

  Future<Products> getSingleProduct(int id) async {
    return await productsWebServices.getSingleProduct(id);
  }

  Future<List<Products>> getSortedProducts(String sortBy, String order) async {
    final prducts = await productsWebServices.getProductsSorted(
      sortBy: sortBy,
      order: order,
    );
    return prducts.map((e) => Products.fromJson(e)).toList();
  }
  Future<List<Products>> searchProducts(String query) async {
    final data = await productsWebServices.searchProducts(query);

    return data.map((e) => Products.fromJson(e)).toList();
  }
  Future<Products> addProduct(Products product) async {
    return await productsWebServices.addProduct(product);

  }
}
