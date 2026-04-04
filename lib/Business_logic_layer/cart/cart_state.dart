part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

final class CartInitialState extends CartState {}
final class CartLoadingState extends CartState {}
final class CartLoadedState extends CartState {
  final List<Products> products;
  final num totalPrice;
  final int totalQuantity;



  CartLoadedState(this.products, {required this.totalPrice, required this.totalQuantity});
}

final class CartErrorState extends CartState {
  final String error;

  CartErrorState(this.error);

}