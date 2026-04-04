import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../data_layer/Recipes/recipes.dart';
import '../../data_layer/Recipes/recipes_repository.dart';
part 'recipes_state.dart';

class RecipesCubit extends Cubit<RecipesState> {
  List<String> tags = [];
  Map<String, int> skipPerTag = {};
  Map<String, List<Recipes>> recipesPerTag = {};
  Map<String, bool> hasMorePerTag = {};
  Map<String, bool> isLoadingPerTag = {};

  String sortBy = "name";
  String order = "asc";

  String selectedTag = ""; // "" تعني الكل (All)
  int limit = 10;

  final RecipesRepository repository;

  RecipesCubit({required this.repository}) : super(RecipesInitialState());

  void initTag(String tag) {
    skipPerTag[tag] = 0;
    recipesPerTag[tag] = [];
    hasMorePerTag[tag] = true;
    isLoadingPerTag[tag] = false;
  }

  Future<void> loadTagsAndFirstRecipes() async {
    try {
      emit(RecipesLoadingState());
      final data = await repository.getAllRecipes(limit: limit, skip: 0);

      tags = _extractTags(data);

      // توحيد "الكل" لتكون قيمتها نص فارغ ""
      initTag("");
      recipesPerTag[""] = data;
      skipPerTag[""] = data.length;
      hasMorePerTag[""] = data.length == limit;
      selectedTag = "";

      emit(RecipesTagloaded(
        tags: tags,
        selectTag: selectedTag,
        recipes: recipesPerTag[""]!,
      ));
    } catch (e) {
      emit(RecipesErrorState(e.toString()));
    }
  }

  void selectTag(String tag) {
    selectedTag = tag;

    // إذا لم نقم بتحميل هذا الـ Tag من قبل، نقوم بتحميله
    if (recipesPerTag[tag] == null || recipesPerTag[tag]!.isEmpty) {
      initTag(tag);
      emit(RecipesLoadingState()); // إظهار التحميل في الـ UI
      fetchRecipesByTag(tag, reset: true);
    } else {
      // إذا كان محملاً مسبقاً، نعرضه فوراً من الكاش
      emit(RecipesTagloaded(
        tags: tags,
        selectTag: selectedTag,
        recipes: recipesPerTag[selectedTag]!,
      ));
    }
  }

  Future<void> fetchRecipesByTag(String tag, {bool reset = false}) async {
    if (isLoadingPerTag[tag] == true) return;
    isLoadingPerTag[tag] = true;

    try {
      final skip = reset ? 0 : (recipesPerTag[tag]?.length ?? 0);

      final newRecipes = await repository.getSortedRecipes(
        sortBy,
        order,
        tag: tag.isEmpty ? null : tag,
        limit: limit,
        skip: skip,
      );

      if (reset) {
        recipesPerTag[tag] = newRecipes;
      } else {
        recipesPerTag[tag]!.addAll(newRecipes);
      }

      hasMorePerTag[tag] = newRecipes.length == limit;

      if (selectedTag == tag) { // نتأكد أن المستخدم ما زال يقف على نفس الـ Tag
        emit(RecipesTagloaded(
          tags: tags,
          selectTag: selectedTag,
          recipes: recipesPerTag[tag] ?? [],
        ));
      }
    } catch (e) {
      emit(RecipesErrorState(e.toString()));
    } finally {
      isLoadingPerTag[tag] = false;
    }
  }

  Future<void> refreshRecipes() async {
    await fetchRecipesByTag(selectedTag, reset: true);
  }

  Future<void> loadMoreRecipes() async {
    if (hasMorePerTag[selectedTag] == true) {
      await fetchRecipesByTag(selectedTag);
    }
  }

  Future<void> sortRecipes({required String sortBy, required String order}) async {
    try {
      emit(RecipesLoadingState());
      this.sortBy = sortBy;
      this.order = order;

      final sorted = await repository.getSortedRecipes(
        sortBy,
        order,
        tag: selectedTag.isEmpty ? null : selectedTag, // استخدام الـ Tag الحالي أثناء الترتيب
        limit: limit,
        skip: 0,
      );

      recipesPerTag[selectedTag] = sorted;
      emit(RecipesTagloaded(
        tags: tags,
        selectTag: selectedTag,
        recipes: sorted,
      ));
    } catch (e) {
      emit(RecipesErrorState(e.toString()));
    }
  }

  // (دوال addRecipe و searchRecipes و _extractTags تبقى كما هي ...)
  Future<void> searchRecipes(String query) async {
    try {
      emit(RecipesLoadingState());
      final result = await repository.searchRecipes(query);
      final searchResults = result.map((e) => Recipes.fromJson(e)).toList();
      emit(SearchRecipesLoaded(searchResults));
    } catch (e) {
      emit(RecipesErrorState(e.toString()));
    }
  }

  Future<void> addRecipe(Recipes recipe) async {
    try {
      emit(AddRecipeLoadingState());
      final newRecipe = await repository.addRecipe(recipe);
      recipesPerTag[""] = [newRecipe, ...recipesPerTag[""]!]; // التعديل هنا لـ ""
      emit(AddRecipeSuccessState(newRecipe));
      if (selectedTag == "") {
        emit(RecipesTagloaded(
          tags: tags,
          selectTag: selectedTag,
          recipes: recipesPerTag[""]!,
        ));
      }
    } catch (e) {
      emit(AddRecipeErrorState(e.toString()));
    }
  }

  List<String> _extractTags(List<Recipes> recipesList) {
    final tagsSet = <String>{};
    for (var recipe in recipesList) {
      if (recipe.tags != null) tagsSet.addAll(recipe.tags!);
    }
    return tagsSet.toList();
  }

  Future<void> getSingleRecipe(int id) async {
    try {
      emit(RecipesLoadingState());

      final recipe = await repository.getSingleRecipe(id);

      emit(SingleRecipeLoaded(recipe)); // ✅ أهم سطر
    } catch (e) {
      emit(RecipesErrorState(e.toString()));
    }
  }
}