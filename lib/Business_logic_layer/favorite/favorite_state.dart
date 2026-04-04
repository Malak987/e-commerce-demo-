part of 'favorite_cubit.dart';

@immutable
sealed class FaveroiteState {}

final class FaveroiteInitialState extends FaveroiteState {}

final class FaveroiteLoadedState extends FaveroiteState {
  final List<Products> favoriteProducts;
  final List<Recipes> favoriteRecipes;

  // دالة getter سهلة للـ UI لمعرفة هل السلة فارغة
  bool get isEmpty => favoriteProducts.isEmpty && favoriteRecipes.isEmpty;

  FaveroiteLoadedState({
    required this.favoriteProducts,
    required this.favoriteRecipes,
  });
}

final class FavouriteErrorState extends FaveroiteState {
  final String message;
  FavouriteErrorState(this.message);
}