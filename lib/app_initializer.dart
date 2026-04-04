import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data_layer/Recipes/recipes.dart';
import 'data_layer/Recipes/recipes_adapter.dart';
import 'data_layer/helper/dio_helper.dart';
import 'data_layer/helper/dio_helper_recipes.dart';
import 'data_layer/products/products.dart';
import 'data_layer/products/products_adapter.dart';
import 'data_layer/user/user.dart';
import 'data_layer/user/user_adapter.dart';

class AppInitializer {
  static Future<void> init() async {
    DioHelper_Products.init();
    DioHelperRecipes.init();
    await Hive.initFlutter();
    Hive.registerAdapter(ProductsAdapter());
    Hive.registerAdapter(RecipesAdapter());
    await Hive.openBox<Products>('cart_box');
    await Hive.openBox<Products>('fav_products_box');
    await Hive.openBox<Recipes>('fav_recipes_box');
    await SharedPreferences.getInstance(); // ✅ init مسبقاً
    print("INIT DONE");
  }
}