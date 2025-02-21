import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartController extends GetxController {
  final RxList<CartItem> _cartItems = <CartItem>[].obs;

  // Getters
  List<CartItem> get cartItems => _cartItems;
  int get itemCount => _cartItems.length;

  // Calculate cart total
  double get cartTotal => _cartItems.fold(
      0, (sum, item) => sum + (item.product.price * item.quantity)
  );

  // Add item to cart
  void addToCart(Product product, String selectedSize, String selectedColor) {
    // Check if the item already exists in cart with the same options
    final existingItemIndex = _cartItems.indexWhere(
            (item) => item.product.id == product.id &&
            item.selectedSize == selectedSize &&
            item.selectedColor == selectedColor
    );

    if (existingItemIndex >= 0) {
      // Update quantity of existing item
      _cartItems[existingItemIndex].quantity++;
    } else {
      // Add new item to cart
      _cartItems.add(
          CartItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            product: product,
            selectedSize: selectedSize,
            selectedColor: selectedColor,
          )
      );
    }

    // Show success snackbar
    Get.snackbar(
      'Added to Cart',
      '${product.name} has been added to your cart',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(16),
    );

    update();
  }

  // Remove item from cart
  void removeFromCart(String cartItemId) {
    _cartItems.removeWhere((item) => item.id == cartItemId);
    update();
  }

  // Update item quantity
  void updateQuantity(String cartItemId, int newQuantity) {
    if (newQuantity < 1) return;

    final index = _cartItems.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      _cartItems[index].quantity = newQuantity;
      update();
    }
  }

  // Clear cart
  void clearCart() {
    _cartItems.clear();
    update();
  }
}