import 'package:e_commerce_prof/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Business_logic_layer/products/products_cubit.dart';
import '../../../data_layer/categories/categories_repository.dart';
import '../../../data_layer/categories/categories_web_services.dart';
import '../../../data_layer/products/products.dart';
import '../../../data_layer/products/products_repository.dart';
import '../../../data_layer/products/products_web_services.dart';

class SingleProductScreen extends StatelessWidget {
  final int productId;

  const SingleProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductsCubit(
        repository: ProductsRepository(productsWebServices: ProductsWebServices()),
        categoriesRepository: CategoriesRepository(categoriesWebServices: CategoriesWebServices()),
      )..getSingleProduct(productId),
      child: Scaffold(
        backgroundColor: Background_Color,
        // ✅ استخدام BlocConsumer فقط (بدون BlocBuilder داخلي)
        body: BlocConsumer<ProductsCubit, ProductsState>(
          listener: (context, state) {
            // ✅ هنا تتعامل مع حالات النجاح والخطأ لو في عمليات جانبية
            if (state is AddProductSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product added successfully!')),
              );
            } else if (state is AddProductErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
            }
          },
          builder: (context, state) {
            if (state is ProductsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductsErrorState) {
              return Center(child: Text(state.error));
            }

            if (state is SingleProductLoadedState) {
              final product = state.product;

              return Stack(

                children: [
                  CustomScrollView(

                    slivers: [

                      // ✅ تم إزالة الزر الخاطئ من هنا

                      /// ===== APP BAR WITH IMAGE =====
                      SliverAppBar(
                        expandedHeight: 430,
                        pinned: true,
                        backgroundColor: Colors.black,
                        leading: const BackButton(color: Colors.white),
                        actions: const [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.favorite_border, color: Colors.white),
                          )
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
                            fit: StackFit.expand,
                            children: [
                              /// Product Image
                              Image.network(
                                (product.images != null && product.images!.isNotEmpty)
                                    ? product.images!.first
                                    : '',
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) =>
                                const Icon(Icons.image, size: 80, color: Colors.grey),
                              ),
                              /// Gradient Overlay
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [Colors.black87, Colors.transparent],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// ===== PRODUCT DETAILS =====
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color:Background_Color,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Title
                              Text(
                                product.title ?? '',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),

                              /// Rating & Stock
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.orange, size: 20),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${product.rating ?? 0}",
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "In Stock",
                                      style: TextStyle(
                                        color: Colors.green.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              /// Price
                              Row(
                                children: [
                                  Text(
                                    "\$${product.price}",
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "\$${(product.price ?? 0).round() + 20}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25),

                              /// Description
                              const Text(
                                "Description",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                product.description ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.6,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 30),

                              /// Image Gallery
                              if (product.images != null && product.images!.isNotEmpty)
                                SizedBox(
                                  height: 80,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: product.images!.length,
                                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                                    itemBuilder: (context, index) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          product.images![index],
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                  ),
                                ),

                              const SizedBox(height: 120), // مساحة للزر العائم
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// ===== ADD TO CART BUTTON =====
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
                      onPressed: () {
                        // ✅ هنا حط كود الإضافة للسلة
                      },
                      child: const Text(
                        "Add To Cart",
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

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}