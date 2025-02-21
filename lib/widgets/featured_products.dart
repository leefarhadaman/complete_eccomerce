import 'package:flutter/material.dart';
import '../models/product_model.dart';

class FeaturedProducts extends StatelessWidget {
  final List<Product> products;

  const FeaturedProducts({required this.products});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            width: 160,
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.images.first,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  product.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('\$${product.price.toStringAsFixed(2)}'),
              ],
            ),
          );
        },
      ),
    );
  }
}