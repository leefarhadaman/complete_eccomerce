import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;

  const ProductGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/product_details', arguments: product);
            },
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
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('\$${product.price.toStringAsFixed(2)}'),
              ],
            ),
          );
        },
        childCount: products.length,
      ),
    );
  }
}
