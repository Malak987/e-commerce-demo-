import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Business_logic_layer/favorite/favorite_cubit.dart';
import '../../../Business_logic_layer/recipes/recipes_cubit.dart';
import '../../../data_layer/Recipes/recipes.dart';
import '../../../data_layer/Recipes/recipes_repository.dart';
import '../../../data_layer/Recipes/recipes_webservices.dart';
import '../../../styles/color.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _prepTimeController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  InputDecoration customInput(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primColor, width: 2),
      ),
    );
  }

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
        BlocProvider(create: (_) => FaveroiteCubit()),
      ],
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Background_Color,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
            title: const Text("Add Recipe"),
            centerTitle: true,
            backgroundColor: primColor,
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocConsumer<RecipesCubit, RecipesState>(
              listener: (context, state) {
                if (state is AddRecipeSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("✅ Recipe added successfully"),
                      backgroundColor: primColor,
                    ),
                  );
                  Navigator.pop(context);
                } else if (state is AddRecipeErrorState) {
                  // طباعة الخطأ في الكونسول للمساعدة في التصحيح
                  print("Error: ${state.error}");

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error: ${state.error}"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      /// 🟢 Title
                      TextFormField(
                        controller: _titleController,
                        decoration: customInput("Recipe Title"),
                        validator: (v) =>
                        v == null || v.isEmpty ? "Required" : null,
                      ),

                      const SizedBox(height: 16),

                      /// 🟢 Preparation Time (Minutes)
                      TextFormField(
                        controller: _prepTimeController,
                        decoration: customInput("Preparation Time (mins)"),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Required";
                          if (int.tryParse(v) == null) return "Invalid number";
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      /// 🟢 Tags (Comma separated)
                      TextFormField(
                        controller: _tagsController,
                        decoration: customInput(
                            "Tags (e.g., Breakfast, Vegan)"),
                        validator: (v) =>
                        v == null || v.isEmpty ? "Required" : null,
                      ),

                      const SizedBox(height: 16),

                      /// 🟢 Description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: customInput("Description"),
                        maxLines: 4,
                      ),

                      const SizedBox(height: 30),

                      /// 🟢 Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: state is AddRecipeLoadingState
                            ? null
                            : () {
                          if (_formKey.currentState!.validate()) {
                            // تحويل التاقز من نص إلى قائمة
                            List<String> tags = _tagsController.text
                                .split(',')
                                .map((tag) => tag.trim())
                                .toList();

                            final recipe = Recipes(
                              // ملاحظة: تأكد أن كلاس Recipes يحتوي على هذه الحقول
                              name: _titleController.text,
                              cookTimeMinutes: int.parse(
                                  _prepTimeController.text),
                              instructions: [_descriptionController.text],
                              tags: tags,
                              image: "https://i.imgur.com/QkIa5tT.jpeg",
                            );

                            context
                                .read<RecipesCubit>()
                                .addRecipe(recipe);
                          }
                        },
                        child: state is AddRecipeLoadingState
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text(
                          "Add Recipe",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}