part of 'recipes_cubit.dart';

@immutable
sealed class RecipesState {}

final class RecipesInitialState extends RecipesState {}

final class RecipesLoadingState extends RecipesState {}

final class RecipesLoadedState extends RecipesState {
  final List<String> tags;
  final List<Recipes> recipes;

  RecipesLoadedState(this.recipes,this.tags);
}

final class RecipesErrorState extends RecipesState {
  final String error;

  RecipesErrorState(this.error);
}

final class RecipesTagloaded extends RecipesState {
  final List<String> tags;
  final String selectTag;
  final List<Recipes> recipes;

  RecipesTagloaded({
    required this.tags,
    required this.selectTag,
    required this.recipes,
  });
}

final class SearchRecipesLoaded extends RecipesState {

  final List<Recipes> recipes;

  SearchRecipesLoaded(this.recipes);
}

final class AddRecipeLoadingState extends RecipesState {}

final class AddRecipeSuccessState extends RecipesState {
  final Recipes newRecipe;

  AddRecipeSuccessState(this.newRecipe);
}

final class AddRecipeErrorState extends RecipesState {
  final String error;

  AddRecipeErrorState(this.error);
}
final class DeleteRecipeLoadingState extends RecipesState {}

final class DeleteRecipeSuccessState extends RecipesState{
  final String message;

  DeleteRecipeSuccessState(this.message);
}

final class DeleteRecipeErrorState extends RecipesState {
  final String error;

  DeleteRecipeErrorState(this.error);
}
class SingleRecipeLoaded extends RecipesState {
  final Recipes recipe;

  SingleRecipeLoaded(this.recipe);
}