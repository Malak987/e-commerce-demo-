part of 'products_cubit.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitialState extends ProductsState {}

final class ProductsLoadingState extends ProductsState {}

final class ProductsLoadedState extends ProductsState {
  final List<Products> products;

  ProductsLoadedState(this.products);
}

final class SingleProductLoadedState extends ProductsState {
  final Products product;

  SingleProductLoadedState(this.product);
}

final class ProductsErrorState extends ProductsState {
  final String error;

  ProductsErrorState(this.error);
}

final class CategoriesLoadedState extends ProductsState {
  final List<String> categories;
  final String selectedCategory;
  final List<Products> products;

  CategoriesLoadedState({
    required this.categories,
    required this.selectedCategory,
    required this.products,
  });
}

class SearchProductsLoadedState extends ProductsState {
  final List<Products> products;

  SearchProductsLoadedState(this.products);
}

final class AddProductLoadingState extends ProductsState {}

final class AddProductSuccessState extends ProductsState {
  final Products newProduct;

  AddProductSuccessState(this.newProduct);
}

final class AddProductErrorState extends ProductsState {
  final String error;

  AddProductErrorState(this.error);
}
