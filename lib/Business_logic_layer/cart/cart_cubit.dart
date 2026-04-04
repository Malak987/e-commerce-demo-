import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../../data_layer/products/products.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitialState());

  Box<Products> get _box => Hive.box<Products>('cart_box');

  // ─── تحميل السلة من Hive عند فتح التطبيق ───
  void getCartItem() {
    emit(CartLoadingState());
    try {
      _updateCartState();
    } catch (e) {
      emit(CartErrorState(e.toString()));
    }
  }

  // ─── إضافة منتج ───────────────────────────
  void addProductToCart(Products product) {
    try {
      if (!_box.containsKey(product.id)) {
        _box.put(product.id, product);
      }
      _updateCartState();
    } catch (e) {
      emit(CartErrorState("Fail To Add Product To Cart ❌"));
    }
  }

  // ─── حذف منتج ─────────────────────────────
  void removeProductFromCart(Products product) {
    try {
      _box.delete(product.id);
      _updateCartState();
    } catch (e) {
      emit(CartErrorState("Failed To Remove Product From Cart ❌"));
    }
  }

  // ─── مسح كل السلة ─────────────────────────
  void clearCart() {
    _box.clear();
    _updateCartState();
  }

  // ─── هل المنتج موجود في السلة؟ ────────────
  bool isInCart(int productId) => _box.containsKey(productId);

  void _updateCartState() {
    final items = _box.values.toList();
    final total = items.fold<int>(
      0,
          (sum, item) => sum + (item.price ?? 0).toInt(),
    );

    emit(CartLoadedState(
      List.from(items),
      totalPrice: total,
      totalQuantity: items.length,
    ));
  }
}