import 'package:e_commerce_prof/Presentation_layer/screens/recipes/search_recipes.dart';
import 'package:e_commerce_prof/Presentation_layer/screens/recipes/single_recipes.dart';
import 'package:e_commerce_prof/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Business_logic_layer/favorite/favorite_cubit.dart';
import '../../../Business_logic_layer/recipes/recipes_cubit.dart';
import '../../../data_layer/Recipes/recipes.dart';
import '../../../data_layer/Recipes/recipes_repository.dart';
import '../../../data_layer/Recipes/recipes_webservices.dart';
import 'add_recipes.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => RecipesCubit(
            repository: RecipesRepository(
              recipesWebservices: RecipesWebservices(),
            ),
          )..loadTagsAndFirstRecipes(),
        ),

      ],
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Background_Color,
          appBar: AppBar(
            title: const Text("Recipes"),
            backgroundColor: primColor,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<RecipesCubit>(),
                        child: const AddRecipeScreen(),
                      ),
                    ),
                  ).then((_) {
                    // refresh بعد العودة
                    final cubit = context.read<RecipesCubit>();
                    cubit.refreshRecipes();
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<RecipesCubit>(),
                        child: SearchScreenRecipes(),
                      ),
                    ),
                  ).then((_) {
                    final cubit = context.read<RecipesCubit>();
                    cubit.refreshRecipes();
                  });
                },
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.sort),
                onSelected: (value) {
                  final cubit = context.read<RecipesCubit>();
                  switch (value) {
                    case "title_asc":
                      cubit.sortRecipes(sortBy: "name", order: "asc");
                      break;
                    case "title_desc":
                      cubit.sortRecipes(sortBy: "name", order: "desc");
                      break;
                    case "prepTime_asc":
                      cubit.sortRecipes(
                        sortBy: "cookTimeMinutes",
                        order: "asc",
                      );
                      break;
                    case "prepTime_desc":
                      cubit.sortRecipes(
                        sortBy: "cookTimeMinutes",
                        order: "desc",
                      );
                      break;
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: "title_asc", child: Text("Name A → Z")),
                  PopupMenuItem(value: "title_desc", child: Text("Name Z → A")),
                  PopupMenuItem(
                    value: "prepTime_asc",
                    child: Text("Time Low → High"),
                  ),
                  PopupMenuItem(
                    value: "prepTime_desc",
                    child: Text("Time High → Low"),
                  ),
                ],
              ),
            ],
          ),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (currentIndex != 0) {
      return const Center(child: Text("Select Recipes Tab"));
    }
    return BlocBuilder<RecipesCubit, RecipesState>(
      builder: (context, state) {
        final cubit = context.read<RecipesCubit>();
        return _RecipesBody(key: ValueKey(cubit.selectedTag));
      },
    );
  }
}class _RecipesBody extends StatefulWidget {
  const _RecipesBody({Key? key}) : super(key: key);
  @override
  State<_RecipesBody> createState() => _RecipesBodyState();
}

class _RecipesBodyState extends State<_RecipesBody> {
  final ScrollController _scrollController = ScrollController();
  final String allTag = "All"; // للاستخدام في الـ UI فقط

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final cubit = context.read<RecipesCubit>();
    final tag = cubit.selectedTag;

    // pagination عند النزول لأسفل
    if (_scrollController.position.extentAfter < 500 &&
        cubit.isLoadingPerTag[tag] != true &&
        cubit.hasMorePerTag[tag] == true) {
      cubit.fetchRecipesByTag(tag);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // الـ watch هنا يراقب الكيوبيت ويحدث الـ Grid أوتوماتيكياً
    final cubit = context.watch<RecipesCubit>();
    final categories = [allTag, ...cubit.tags];

    final recipes = cubit.recipesPerTag[cubit.selectedTag] ?? [];

    return RefreshIndicator(
      onRefresh: () => cubit.refreshRecipes(),
      child: Column(
        children: [
          SizedBox(
            height: 55,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, index) {
                final tag = categories[index];
                final isSelected = (tag == allTag && cubit.selectedTag.isEmpty) || cubit.selectedTag == tag;

                return ChoiceChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (_) {
                    if (tag == allTag) {
                      cubit.selectTag(""); // نص فارغ تعني الكل
                    } else {
                      cubit.selectTag(tag);
                    }
                  },
                  selectedColor: primColor,
                  backgroundColor: Colors.grey.shade200,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                );
              },
            ),
          ),
          Expanded(
            child: recipes.isEmpty && cubit.isLoadingPerTag[cubit.selectedTag] == true
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: recipes.length + (cubit.hasMorePerTag[cubit.selectedTag] == true ? 1 : 0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (_, index) {
                if (index >= recipes.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _RecipesCard(recipe: recipes[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
class _RecipesCard extends StatefulWidget {
  final Recipes recipe;
  const _RecipesCard({required this.recipe});

  @override
  State<_RecipesCard> createState() => _RecipesCardState();
}

class _RecipesCardState extends State<_RecipesCard> {


  @override
  Widget build(BuildContext context) {
    final image = widget.recipe.image;

    return Material(
      color: primColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (widget.recipe.id == null) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<RecipesCubit>(),
                child: SingleRecipeScreen(
                  recipeId: widget.recipe.id!,
                ),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 1.2,
                  child: Container(
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: image == null
                              ? const Icon(Icons.image_not_supported)
                              : Image.network(image, fit: BoxFit.cover),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: BlocBuilder<FaveroiteCubit, FaveroiteState>(
                              builder: (context, favState) {
                                final isFav = context
                                    .read<FaveroiteCubit>()
                                    .isRecipeFavorite(widget.recipe.id!);
                                return IconButton(
                                  icon: Icon(
                                    isFav ? Icons.favorite : Icons.favorite_border,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<FaveroiteCubit>()
                                        .toggleRecipeFavorite(widget.recipe);
                                  },
                                );
                              },
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.recipe.name ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const Spacer(),
              Text(
                "Time: ${widget.recipe.cookTimeMinutes ?? 0} mins",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}