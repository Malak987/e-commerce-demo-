import 'package:e_commerce_prof/Business_logic_layer/products/products_cubit.dart';
import 'package:e_commerce_prof/Presentation_layer/screens/products/singleProduct.dart';
import 'package:e_commerce_prof/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Business_logic_layer/cart/cart_cubit.dart';
import '../../../Business_logic_layer/favorite/favorite_cubit.dart';
import '../../../data_layer/categories/categories_repository.dart';
import '../../../data_layer/categories/categories_web_services.dart';
import '../../../data_layer/products/products.dart';
import '../../../data_layer/products/products_repository.dart';
import '../../../data_layer/products/products_web_services.dart';
import 'search.dart';
import 'add_product.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductsCubit(
            repository: ProductsRepository(
              productsWebServices: ProductsWebServices(),
            ),
            categoriesRepository: CategoriesRepository(
              categoriesWebServices: CategoriesWebServices(),
            ),
          )..loadCategoriesAndFirstProducts(),
        ),


      ],
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Background_Color,
          appBar: AppBar(
            title: const Text("Products"),
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
                        value: context.read<ProductsCubit>(),
                        child: const AddProductScreen(),
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<ProductsCubit>(),
                        child: SearchScreen(),
                      ),
                    ),
                  );
                },
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.sort),
                onSelected: (value) {
                  final cubit = context.read<ProductsCubit>();

                  switch (value) {
                    case "title_asc":
                      cubit.sortProducts(sortBy: "title", order: "asc");
                      break;
                    case "title_desc":
                      cubit.sortProducts(sortBy: "title", order: "desc");
                      break;
                    case "price_asc":
                      cubit.sortProducts(sortBy: "price", order: "asc");
                      break;
                    case "price_desc":
                      cubit.sortProducts(sortBy: "price", order: "desc");
                      break;
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: "title_asc", child: Text("Name A → Z")),
                  PopupMenuItem(value: "title_desc", child: Text("Name Z → A")),
                  PopupMenuItem(
                    value: "price_asc",
                    child: Text("Price Low → High"),
                  ),
                  PopupMenuItem(
                    value: "price_desc",
                    child: Text("Price High → Low"),
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
    if (currentIndex != 1) {
      return const Center(child: Text("Other Pages"));
    }

    return const _ProductsBody();
  }
}

class _ProductsBody extends StatelessWidget {
  const _ProductsBody();


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProductsErrorState) {
          return Center(child: Text(state.error));
        }

        if (state is CategoriesLoadedState) {
          return Column(
            children: [
              _CategoriesBar(
                categories: state.categories,
                selected: state.selectedCategory,
                onSelected: context.read<ProductsCubit>().selectCategory,
              ),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: state.products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (_, index) {
                    return _ProductCard(product: state.products[index]);
                  },
                ),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Products product;

   _ProductCard({required this.product});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {



  @override
  Widget build(BuildContext context) {
    final image = widget.product.images?.isNotEmpty == true ? widget.product.images!.first : null;

    return Material(
      color: primColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (widget.product.id == null) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SingleProductScreen(productId: widget.product.id!.toInt()),
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
                        // زر المفضلة
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: BlocBuilder<FaveroiteCubit, FaveroiteState>(
                              builder: (context, favState) {
                                final isFav = context
                                    .read<FaveroiteCubit>()
                                    .isProductFavorite(widget.product.id!);
                                return IconButton(
                                  icon: Icon(
                                    isFav ? Icons.favorite : Icons.favorite_border,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<FaveroiteCubit>()
                                        .toggleProductFavorite(widget.product);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        // 🛒 زر السلة (مربوط بالكيوبيت مباشرة)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: BlocBuilder<CartCubit, CartState>(
                            builder: (context, state) {
                              bool isItemInCart = false;
                              if (state is CartLoadedState) {
                                isItemInCart = state.products.any((p) => p.id == widget.product.id);
                              }

                              return Container(
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: IconButton(
                                  icon: Icon(
                                    isItemInCart ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                                    color: primColor,
                                  ),
                                  onPressed: () {
                                    final cartCubit = context.read<CartCubit>();
                                    if (isItemInCart) {
                                      cartCubit.removeProductFromCart(widget.product);
                                    } else {
                                      cartCubit.addProductToCart(widget.product);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("${widget.product.title} added to cart"), duration: const Duration(seconds: 1)),
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(widget.product.title ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white)),
              const Spacer(),
              Text("\$${widget.product.price ?? 0}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoriesBar extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  const _CategoriesBar({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 10),

        itemBuilder: (context, index) {
          final isAll = index == 0;
          final categoryName = isAll ? "all" : categories[index - 1];

          final isSelected =
              categoryName.toLowerCase() == selected.toLowerCase();

          return ChoiceChip(
            label: Text(isAll ? "All" : categoryName),

            selected: isSelected,

            onSelected: (_) {
              onSelected(categoryName);
            },

            selectedColor: primColor,
            backgroundColor: Colors.grey.shade200,

            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),

            side: BorderSide(
              color: isSelected ? primColor : Colors.grey.shade300,
            ),
          );
        },
      ),
    );
  }
}
