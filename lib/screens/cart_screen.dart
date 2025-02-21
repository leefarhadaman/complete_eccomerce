import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../utils/animations.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        actions: [
          if (cartController.itemCount > 0)
            IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    title: Text('Clear Cart'),
                    content: Text('Are you sure you want to remove all items from your cart?'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          cartController.clearCart();
                          Get.back();
                        },
                        child: Text('Clear'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Obx(() {
        if (cartController.itemCount == 0) {
          return Center(
            child: FadeAnimation(
              0.2,
              Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          );
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartController.cartItems[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        leading: Image.network(item.product.images.isNotEmpty ? item.product.images[0] : 'https://via.placeholder.com/150'),
                        title: Text(item.product.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Size: ${item.selectedSize} | Color: ${item.selectedColor}'),
                            Text('Price: \$${item.product.price.toStringAsFixed(2)}'),
                            Text('Quantity: ${item.quantity}'),
                          ],
                        ),
                        trailing: Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                cartController.updateQuantity(item.id, item.quantity + 1);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                cartController.updateQuantity(item.id, item.quantity - 1);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                cartController.removeFromCart(item.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Total: \$${cartController.cartTotal.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: cartController.itemCount == 0 ? null : () {},
                      child: Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
