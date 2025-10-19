import 'package:ecommerce_app/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartNotifier extends Notifier<List<Product>>{
  @override
  List<Product> build(){
    return [
      Product(
        id: 1,
        name: "USDA Organic Beetroot Powder 250g",
        imagePath: "assets/products/card1.webp",
        oldPrice: "",
        newPrice: "BDT 1,000.00",
        discount: "",
      ),
    ];
  }
  void addToCart(Product product){
    state = [...state, product];
  }
  void removeFromCart(Product product) {
    final index = state.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      state = [
        ...state.sublist(0, index),
        ...state.sublist(index + 1),
      ];
    }
  }
}

final cartNotifierProvider = NotifierProvider<CartNotifier, List<Product>>((){
  return CartNotifier();
});

final cartTotalProvider = Provider<double>((ref) {
  final cartProducts = ref.watch(cartNotifierProvider);
  double total = 0;

  for (final product in cartProducts) {
    // Remove commas and parse as double
    final price = double.tryParse(
      product.newPrice.replaceAll(RegExp(r'[^\d.]'), ''), // remove everything except digits and dot
    ) ?? 0;
    total += price;
  }

  return total;
});