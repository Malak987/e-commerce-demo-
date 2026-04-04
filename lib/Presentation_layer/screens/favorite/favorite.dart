import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Business_logic_layer/cart/cart_cubit.dart';
import '../../../Business_logic_layer/favorite/favorite_cubit.dart';
import '../../../Business_logic_layer/recipes/recipes_cubit.dart';
import '../../../data_layer/Recipes/recipes.dart';
import '../../../data_layer/Recipes/recipes_repository.dart';
import '../../../data_layer/Recipes/recipes_webservices.dart';
import '../../../data_layer/products/products.dart';
import '../../../styles/color.dart';
import '../products/singleProduct.dart';
import '../recipes/single_recipes.dart'; // تأكد من المسارات لديك

class FavoriteScreen extends StatefulWidget {
   FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
// في FavoriteScreen حولها لـ StatefulWidget وأضف:
  @override
  void initState() {
    super.initState();
    context.read<FaveroiteCubit>().loadFavorites(); // ← يحمل من Hive
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // تبويبين: منتجات ووصفات
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text(
            "My Wishlist",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: primColor,
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.shopping_bag), text: "Products"),
              Tab(icon: Icon(Icons.restaurant_menu), text: "Recipes"),
            ],
          ),
        ),
        body: BlocBuilder<FaveroiteCubit, FaveroiteState>(
          builder: (context, state) {
            if (state is FaveroiteInitialState) {
              return _buildEmptyState(context);
            }

            if (state is FaveroiteLoadedState) {
              if (state.isEmpty) {
                return _buildEmptyState(context);
              }

              return TabBarView(
                children: [
                  // 🛒 التبويب الأول: المنتجات
                  _buildProductsGrid(context, state.favoriteProducts),

                  // 🍲 التبويب الثاني: الوصفات
                  _buildRecipesGrid(context, state.favoriteRecipes),
                ],
              );
            }

            if (state is FavouriteErrorState) {
              return Center(child: Text(state.message));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  // --- واجهة المنتجات الشبكية ---
  Widget _buildProductsGrid(BuildContext context, List<Products> products) {
    if (products.isEmpty) {
      return _buildNoItemsInTab(Icons.shopping_bag_outlined, "No Products in Wishlist");
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) => _ProductFavoriteCard(product: products[index]),
    );
  }

  // --- واجهة الوصفات الشبكية ---
  Widget _buildRecipesGrid(BuildContext context, List<Recipes> recipes) {
    if (recipes.isEmpty) {
      return _buildNoItemsInTab(Icons.restaurant_menu, "No Recipes in Wishlist");
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recipes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) => _RecipeFavoriteCard(recipe: recipes[index]),
    );
  }

  // --- واجهة Empty State العامة ---
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border_rounded, size: 100, color: Colors.grey.shade400),
          const SizedBox(height: 20),
          const Text("Your Wishlist is Empty!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text("Save items and recipes you love here.", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // --- واجهة Empty State لتبويب واحد فقط ---
  Widget _buildNoItemsInTab(IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 70, color: Colors.grey.shade300),
          const SizedBox(height: 15),
          Text(message, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}

// =================== كارت المنتج المفضل ===================
class _ProductFavoriteCard extends StatelessWidget {
  final Products product;
  const _ProductFavoriteCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final image = product.images?.isNotEmpty == true ? product.images!.first : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SingleProductScreen(productId: product.id!.toInt()))),
                    child: image != null ? Image.network(image, width: double.infinity, fit: BoxFit.cover) : const Icon(Icons.image_not_supported),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 18,
                    child: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red, size: 20),
                      onPressed: () => context.read<FaveroiteCubit>().toggleProductFavorite(product),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title ?? "", maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("\$${product.price ?? 0}", style: TextStyle(color: primColor, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.add_shopping_cart, color: primColor),
                        onPressed: () => context.read<CartCubit>().addProductToCart(product),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// =================== كارت الوصفة المفضلة ===================
class _RecipeFavoriteCard extends StatelessWidget {
  final Recipes recipe;
  const _RecipeFavoriteCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => RecipesCubit(
                            repository: RecipesRepository(
                              recipesWebservices: RecipesWebservices(),
                            ),
                          ),
                          child: SingleRecipeScreen(recipeId: recipe.id!.toInt()),
                        ),
                      ),
                    ),
                    child: recipe.image != null ? Image.network(recipe.image!, width: double.infinity, fit: BoxFit.cover) : const Icon(Icons.image_not_supported),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 18,
                    child: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red, size: 20),
                      onPressed: () => context.read<FaveroiteCubit>().toggleRecipeFavorite(recipe),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.name ?? "", maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 5),
                      Text("${recipe.cookTimeMinutes ?? 0} mins", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}