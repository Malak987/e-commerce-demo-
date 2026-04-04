import '../products/products.dart';


enum CartStatus { initial, loading, loaded, error }

class CartState {
  final List<Products> products;
  final int totalPrice;
  final int totalQuantity;
  final CartStatus status;
  final String errorMessage;

  CartState({
    this.products = const [],
    this.totalPrice = 0,
    this.totalQuantity = 0,
    this.status = CartStatus.initial,
    this.errorMessage = '',
  });

  CartState copyWith({
    List<Products>? products,
    int? totalPrice,
    int? totalQuantity,
    CartStatus? status,
    String? errorMessage,
  }) {
    return CartState(
      products: products ?? this.products,
      totalPrice: totalPrice ?? this.totalPrice,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}