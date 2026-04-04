import 'package:e_commerce_prof/Presentation_layer/screens/products/singleProduct.dart';
import 'package:e_commerce_prof/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Business_logic_layer/products/products_cubit.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final TextEditingController controller = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: primColor,
        title: const Text("Search Products",style: TextStyle(color: Colors.white),),
      ),

      body: Column(
        children: [
          /// Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Search for products...",
                filled: true,
                fillColor: Colors.white,

                prefixIcon: Icon(Icons.search, color: primColor),

                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                  },
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),

              onSubmitted: (value) {
                context.read<ProductsCubit>().searchProducts(value);
              },
            ),
          ),

          /// Results
          Expanded(
            child: BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                if (state is ProductsLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is SearchProductsLoadedState) {
                  if (state.products.isEmpty) {
                    return const Center(child: Text("No products found"));
                  }

                  return ListView.builder(
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),

                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SingleProductScreen(productId: product.id!),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                product.thumbnail ?? "",
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),

                            title: Text(
                              product.title ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Text("\$${product.price}"),

                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: primColor,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return const Center(child: Text("Start searching..."));
              },
            ),
          ),
        ],
      ),
    );
  }
}
