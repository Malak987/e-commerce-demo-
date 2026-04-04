import 'package:e_commerce_prof/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Business_logic_layer/cart/cart_cubit.dart';
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int currentIndex = 3;
  // في CartScreen أضف initState:
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().getCartItem(); // ← يحمل من Hive
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text("Cart", style: TextStyle(color: Colors.white))),
        backgroundColor: primColor,
      ),
      // 👈 تم مسح الـ BlocProvider من هنا لكي لا ينشئ كيوبيت جديد فارغ
      body: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state is CartLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is CartLoadedState) {
                if (state.products.isEmpty) {
                  return const Center(child: Text("No Items In Cart"));
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                  final product = state.products[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        /// 🖼️ الصورة
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: product.images != null && product.images!.isNotEmpty
                              ? Image.network(
                            product.images!.first,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          )
                              : Container(
                            width: 90,
                            height: 90,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image),
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// 📄 البيانات
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "${product.price} USD",
                                style: TextStyle(
                                  color: primColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  const Icon(Icons.shopping_cart, size: 16, color: Colors.grey),
                                  const SizedBox(width: 5),
                                  Text(
                                    "In Cart",
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        /// ❌ زرار الحذف
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context.read<CartCubit>().removeProductFromCart(product);
                          },
                        ),
                      ],
                    ),
                  );
                }
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      color: primColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Quantity : ${state.totalQuantity}",style: TextStyle(color: Colors.white),),
                          Text("Total Price : ${state.totalPrice} USD",style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    )
                  ],
                );
              }

              if (state is CartErrorState) {
                return Center(child: Text(state.error));
              }

              return const Center(child: Text("Start shopping now!"));
            },
          ),
    );
  }
}