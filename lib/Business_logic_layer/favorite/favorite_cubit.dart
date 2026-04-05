import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../../data_layer/Recipes/recipes.dart';
import '../../data_layer/products/products.dart';

part 'favorite_state.dart';

class FaveroiteCubit extends Cubit<FaveroiteState> {
  FaveroiteCubit() : super(FaveroiteInitialState());

  Box<Products> get _productsBox => Hive.box<Products>('fav_products_box');
  Box<Recipes>  get _recipesBox  => Hive.box<Recipes>('fav_recipes_box');

  // ─── تحميل المفضلة عند الفتح ──────────────
  void loadFavorites() {
    _emitState();
  }

  // ─── Products ─────────────────────────────
  void toggleProductFavorite(Products product) {
    if (_productsBox.containsKey(product.id)) {
      _productsBox.delete(product.id);
    } else {
      _productsBox.put(product.id, product);
    }
    _emitState();
  }

  bool isProductFavorite(int id) => _productsBox.containsKey(id);

  // ─── Recipes ──────────────────────────────
  void toggleRecipeFavorite(Recipes recipe) {
    if (_recipesBox.containsKey(recipe.id)) {
      _recipesBox.delete(recipe.id);
    } else {
      _recipesBox.put(recipe.id, recipe);
    }
    _emitState();
  }

  bool isRecipeFavorite(int id) => _recipesBox.containsKey(id);

  void _emitState() {
    emit(FaveroiteLoadedState(
      favoriteProducts: _productsBox.values.toList(),
      favoriteRecipes:  _recipesBox.values.toList(),
    ));
  }
  Future<void> clearFavoritesOnLogout() async {
    await _productsBox.clear();
    await _recipesBox.clear();
    emit(FaveroiteInitialState());
  }
}