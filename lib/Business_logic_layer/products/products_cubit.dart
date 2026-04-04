import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data_layer/categories/categories_repository.dart';
import '../../data_layer/products/products.dart';
import '../../data_layer/products/products_repository.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  List<Products> products = [];
  final ProductsRepository repository;
  final CategoriesRepository categoriesRepository;

  ProductsCubit({required this.repository, required this.categoriesRepository})
    : super(ProductsInitialState());

  Future<void> getAllProducts() async {
    try {
      emit(ProductsLoadingState());
      final products = await repository.getAllProducts();
      emit(ProductsLoadedState(products));
    } catch (e) {
      emit(ProductsErrorState(e.toString()));
    }
  }

  Future<void> getSingleProduct(int id) async {
    try {
      emit(ProductsLoadingState());
      final product = await repository.getSingleProduct(id);
      emit(SingleProductLoadedState(product));
    } catch (e) {
      emit(ProductsErrorState(e.toString()));
    }
  }

  Future<void> loadCategoriesAndFirstProducts() async {
    try {
      emit(ProductsLoadingState());

      final categories = await categoriesRepository.getCategories();
      final first = categories.isNotEmpty ? categories.first : '';

      final products = first.isEmpty
          ? <Products>[]
          : await categoriesRepository.getProductsByCategory(first);

      emit(
        CategoriesLoadedState(
          categories: categories,
          selectedCategory: first,
          products: products,
        ),
      );
    } catch (e) {
      emit(ProductsErrorState(e.toString()));
    }
  }

  Future<void> selectCategory(String category) async {
    try {
      final current = state;
      if (current is CategoriesLoadedState) {
        emit(ProductsLoadingState());
        // ✅ حالة All: نرجع كل المنتجات (يفضل تكون محملة مسبقًا أو كاش)
        if (category.toLowerCase() == 'all') {
          // هنا المفروض ترجع كل المنتجات المخزنة محليًا عشان السرعة
          // لو مش مخزنة، ممكن تستدعي دالة getAllProducts()
          final allProducts = await repository.getAllProducts();

          emit(
            CategoriesLoadedState(
              categories: current.categories,
              selectedCategory: 'all',
              products: allProducts,
            ),
          );
          return;
        }

        final products = await categoriesRepository.getProductsByCategory(
          category,
        );

        emit(
          CategoriesLoadedState(
            categories: current.categories,
            selectedCategory: category,
            products: products,
          ),
        );
      }
    } catch (e) {
      emit(ProductsErrorState(e.toString()));
    }
  }

  Future<void> sortProducts({
    required String sortBy,
    required String order,
  }) async {
    final currentState = state;

    // لو الحالة الحالية فيها منتجات بعد اختيار كاتيجوري
    if (currentState is CategoriesLoadedState) {
      List<Products> sorted = List.from(currentState.products);

      // Sort على حسب المطلوب
      if (sortBy == 'title') {
        sorted.sort((a, b) {
          final aTitle = a.title ?? '';
          final bTitle = b.title ?? '';
          return order == 'asc'
              ? aTitle.compareTo(bTitle)
              : bTitle.compareTo(aTitle);
        });
      } else if (sortBy == 'price') {
        sorted.sort((a, b) {
          final aPrice = a.price ?? 0;
          final bPrice = b.price ?? 0;
          return order == 'asc' ? aPrice.compareTo(bPrice) : bPrice.compareTo(aPrice);
        });
      }

      emit(CategoriesLoadedState(
        categories: currentState.categories,
        selectedCategory: currentState.selectedCategory,
        products: sorted,
      ));
    }
  }
  Future<void> searchProducts(String query) async {
    try {
      emit(ProductsLoadingState());

      final products = await repository.searchProducts(query);

      emit(SearchProductsLoadedState(products));
    } catch (e) {
      emit(ProductsErrorState(e.toString()));
    }
  }
  Future<void> addProduct(Products product) async {
    try {
      emit(ProductsLoadingState());

      final newProduct = await repository.addProduct(product);
      products.add(newProduct);

      if (state is CategoriesLoadedState) {
        final current = state as CategoriesLoadedState;
        emit(CategoriesLoadedState(
          categories: current.categories,
          selectedCategory: current.selectedCategory,
          products: products, // القائمة المحدثة
        ));
      } else if (state is ProductsLoadedState) {
        emit(ProductsLoadedState(products));
      }

      // 4. إصدار حالة النجاح عشان الـ UI يعرف يปิด الـ Dialog ويظهر رسالة
      emit(AddProductSuccessState(newProduct));

    } catch (e) {
      emit(AddProductErrorState(e.toString()));
    }
  }
}
