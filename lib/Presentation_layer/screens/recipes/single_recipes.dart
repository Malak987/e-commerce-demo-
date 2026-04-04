import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Business_logic_layer/recipes/recipes_cubit.dart';
import '../../../styles/color.dart';

class SingleRecipeScreen extends StatefulWidget {
  final int recipeId;

  const SingleRecipeScreen({super.key, required this.recipeId});

  @override
  State<SingleRecipeScreen> createState() => _SingleRecipeScreenState();
}

class _SingleRecipeScreenState extends State<SingleRecipeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RecipesCubit>().getSingleRecipe(widget.recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background_Color,
      body: BlocBuilder<RecipesCubit, RecipesState>(
        builder: (context, state) {
          if (state is RecipesLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RecipesErrorState) {
            return Center(child: Text(state.error));
          }

          if (state is SingleRecipeLoaded) {
            final recipe = state.recipe;

            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    /// 🔥 الصورة + AppBar
                    SliverAppBar(
                      expandedHeight: 350,
                      pinned: true,
                      backgroundColor: Colors.black,
                      leading: const BackButton(color: Colors.white),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              recipe.image ?? "",
                              fit: BoxFit.cover,
                            ),

                            /// Gradient
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black87,
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// 📦 التفاصيل
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Background_Color,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(25),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// 🟡 اسم الوصفة
                            Text(
                              recipe.name ?? "",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            /// ⏱️ الوقت + التاج
                            Row(
                              children: [
                                if (recipe.tags != null &&
                                    recipe.tags!.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: primColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      recipe.tags!.first,
                                      style: TextStyle(
                                        color: primColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                const SizedBox(width: 12),

                                const Icon(Icons.timer, size: 18),
                                const SizedBox(width: 5),

                                Text(
                                  "${recipe.cookTimeMinutes ?? 0} mins",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 25),

                            /// 📖 عنوان الخطوات
                            const Text(
                              "Steps",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 15),

                            /// 🔥 الخطوات المرقمة
                            Column(
                              children: List.generate(
                                recipe.instructions?.length ?? 0,
                                    (index) {
                                  final step =
                                      recipe.instructions?[index] ?? "";

                                  return Container(
                                    margin:
                                    const EdgeInsets.only(bottom: 15),
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                          Colors.black.withOpacity(0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        /// 🔢 رقم الخطوة
                                        Container(
                                          width: 35,
                                          height: 35,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: primColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            "${index + 1}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 12),

                                        /// ✍️ النص
                                        Expanded(
                                          child: Text(
                                            step,
                                            style: const TextStyle(
                                              height: 1.6,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                /// 🔘 زر تحت
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Start Cooking 🍳",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}