import 'package:eccomerceapp/models/product_model.dart';

class CartItem {
  final String id;
  final Product product;
  final String selectedSize;
  final String selectedColor;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
    this.quantity = 1,
  });
}
