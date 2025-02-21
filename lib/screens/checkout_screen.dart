import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ------------------ Checkout Controller ------------------
class CheckoutController extends GetxController {
  var address = ''.obs;
  var paymentMethod = ''.obs;

  void updateAddress(String newAddress) {
    address.value = newAddress;
  }

  void updatePaymentMethod(String method) {
    paymentMethod.value = method;
  }

  void placeOrder() {
    // Simulate placing order
    Get.snackbar('Order Placed', 'Your order has been placed successfully!', snackPosition: SnackPosition.BOTTOM);
  }
}

// ------------------ Checkout Screen ------------------
class CheckoutScreen extends StatelessWidget {
  final CheckoutController checkoutController = Get.put(CheckoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shipping Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              onChanged: checkoutController.updateAddress,
              decoration: InputDecoration(hintText: 'Enter your address'),
            ),
            SizedBox(height: 20),
            Text('Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: checkoutController.paymentMethod.value.isEmpty ? null : checkoutController.paymentMethod.value,
              hint: Text('Select Payment Method'),
              items: ['Credit Card', 'PayPal', 'Cash on Delivery']
                  .map((method) => DropdownMenuItem(value: method, child: Text(method)))
                  .toList(),
              onChanged: (value) => checkoutController.updatePaymentMethod(value!),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: checkoutController.placeOrder,
              child: Center(child: Text('Place Order')),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
            ),
          ],
        ),
      ),
    );
  }
}

