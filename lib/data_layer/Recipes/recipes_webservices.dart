import 'package:e_commerce_prof/data_layer/Recipes/recipes.dart';

import '../../networks/end_points.dart';
import '../helper/dio_helper_recipes.dart';

class RecipesWebservices {

  Future<List<Recipes>> getAllRecipes({int limit = 10, int skip = 0}) async {
    final response = await DioHelperRecipes.getDataRecipes(
      url: allRecipesPath(limit: limit, skip: skip),
    );
    return (response.data['recipes'] as List)
        .map((e) => Recipes.fromJson(e))
        .toList();
  }

  Future<Recipes> getSingleRecipe(int id) async {
    final response = await DioHelperRecipes.getDataRecipes(
      url: SingleRECIPESID(id),
    );
    return Recipes.fromJson(response.data);
  }

  // تعديل هنا للـ Sort والـ Tag معاً
  Future<List<dynamic>> getRecipesSorted({
    required String sortBy,
    required String order,
    int limit = 10,
    int skip = 0,
    String? tag,
  }) async {
    // إذا كان هناك tag نضرب endpoint الخاص بالـ tag، وإذا لم يوجد نضرب الـ endpoint العام
    String path = (tag != null && tag.isNotEmpty)
        ? recipesByTagPath(tag, limit: limit, skip: skip)
        : allRecipesPath(limit: limit, skip: skip);

    final response = await DioHelperRecipes.getDataRecipes(
      url: path,
      query: {"sortBy": sortBy, "order": order},
    );
    return response.data['recipes'];
  }

  Future<List<dynamic>> searchRecipes(String query) async {
    final response = await DioHelperRecipes.getDataRecipes(
      url: RECIPES_SEARCH,
      query: {"q": query},
    );
    return response.data['recipes'];
  }

  Future<Recipes> addRecipe(Recipes recipe) async {
    final response = await DioHelperRecipes.postDataRecipes(
        url: RECIPES_ADD, data: recipe.toJson());
    return Recipes.fromJson(response.data);
  }

  Future<void> DeleteRecipe(int id) async {
    await DioHelperRecipes.DeleteDataRecipes(
      url: SingleRECIPESID(id),
    );
  }
}