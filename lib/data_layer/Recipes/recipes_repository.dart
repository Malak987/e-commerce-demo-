import 'package:e_commerce_prof/data_layer/Recipes/recipes.dart';
import 'package:e_commerce_prof/data_layer/Recipes/recipes_webservices.dart';

class RecipesRepository {
  RecipesWebservices recipesWebservices;

  RecipesRepository({required this.recipesWebservices});

  Future<List<Recipes>> getAllRecipes({int limit = 10, int skip = 0}) async {
    return await recipesWebservices.getAllRecipes(limit: limit, skip: skip);
  }

  Future<Recipes> getSingleRecipe(int id) async {
    return await recipesWebservices.getSingleRecipe(id);
  }

  // تعديل الـ getSortedRecipes لتأخذ tag
  Future<List<Recipes>> getSortedRecipes(String sortBy, String order, {int limit = 10, int skip = 0, String? tag}) async {
    final data = await recipesWebservices.getRecipesSorted(
      sortBy: sortBy,
      order: order,
      limit: limit,
      skip: skip,
      tag: tag, // تمرير التاج
    );
    return data.map<Recipes>((e) => Recipes.fromJson(e)).toList();
  }

  Future<List<dynamic>> searchRecipes(String query) async {
    return await recipesWebservices.searchRecipes(query);
  }

  Future<Recipes> addRecipe(Recipes recipe) async {
    return await recipesWebservices.addRecipe(recipe);
  }

  Future<String> deleteRecipe(int id) async {
    await recipesWebservices.DeleteRecipe(id);
    return "Deleted Successfully";
  }
}