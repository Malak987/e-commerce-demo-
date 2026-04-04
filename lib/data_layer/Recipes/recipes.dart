import 'dart:core';

class AllRecipes {
  List<Recipes>? recipes;
  int? total;
  int? skip;
  int? limit;
  AllRecipes({this.recipes, this.total, this.skip, this.limit});
  AllRecipes.fromJson(Map<String,dynamic> json){
    if(json['recipes'] != null){
      recipes = <Recipes>[];
      json['recipes'].forEach((v){
        recipes!.add(Recipes.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.recipes != null) {
      data['recipes'] = this.recipes!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['skip'] = this.skip;
    data['limit'] = this.limit;
    return data;
  }


}
class Recipes {
  int? id;
  String? name;
  List<String>? ingredients;
  List<String>? instructions;
  int? prepTimeMinutes;
  int? cookTimeMinutes;
  int? servings;
  String? difficulty;
  String? cuisine;
  int? caloriesPerServing;
  List<String>? tags;
  int? userId;
  String? image;
  double? rating;
  int? reviewCount;
  List<String>? mealType;

  Recipes(
      {this.id,
        this.name,
        this.ingredients,
        this.instructions,
        this.prepTimeMinutes,
        this.cookTimeMinutes,
        this.servings,
        this.difficulty,
        this.cuisine,
        this.caloriesPerServing,
        this.tags,
        this.userId,
        this.image,
        this.rating,
        this.reviewCount,
        this.mealType});
  Recipes.fromJson(Map<String,dynamic> json){
    id = json['id'];
    name = json['name'];

    ingredients = (json['ingredients'] ?? [])
        .map<String>((e) => e.toString())
        .toList();

    instructions = (json['instructions'] ?? [])
        .map<String>((e) => e.toString())
        .toList();

    prepTimeMinutes = json['prepTimeMinutes'];
    cookTimeMinutes = json['cookTimeMinutes'];
    servings = json['servings'];
    difficulty = json['difficulty'];
    cuisine = json['cuisine'];
    caloriesPerServing = json['caloriesPerServing'];

    tags = (json['tags'] ?? [])
        .map<String>((e) => e.toString())
        .toList();

    userId = json['userId'];
    image = json['image'];
    rating = (json['rating'] as num?)?.toDouble();
    reviewCount = json['reviewCount'];

    mealType = (json['mealType'] ?? [])
        .map<String>((e) => e.toString())
        .toList();
  }
  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String, dynamic> ();
    data['id'] = this.id;
    data['name'] = this.name;
    data['ingredients'] = this.ingredients;
    data['instructions'] = this.instructions;
    data['prepTimeMinutes'] = this.prepTimeMinutes;
    data['cookTimeMinutes'] = this.cookTimeMinutes;
    data['servings'] = this.servings;
    data['difficulty'] = this.difficulty;
    data['cuisine'] = this.cuisine;
    data['caloriesPerServing'] = this.caloriesPerServing;
    data['tags'] = this.tags;
    data['userId'] = this.userId;
    data['image'] = this.image;
    data['rating'] = this.rating;
    data['reviewCount'] = this.reviewCount;
    data['mealType'] = this.mealType;
    return data;

  }


}
