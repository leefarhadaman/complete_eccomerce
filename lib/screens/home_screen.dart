import 'package:eccomerceapp/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../widgets/category_slider.dart';
import '../widgets/featured_products.dart';
import '../widgets/product_grid.dart';
import '../widgets/search_bar.dart';
import '../utils/animations.dart';

class HomeScreen extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ShopEase',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // Navigate to favorites screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Get.toNamed('/cart');
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Obx(() {
        if (productController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => productController.fetchProducts(),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 🔍 Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: FadeAnimation(
                    0.1,
                    CustomSearchBar(
                      onSearch: (query) {
                        productController.searchProducts(query);
                      },
                    ),
                  ),
                ),
              ),

              // 📂 Category Slider
              SliverToBoxAdapter(
                child: FadeAnimation(
                  0.2,
                  CategorySlider(
                    categories: productController.categories,
                    selectedCategory: productController.selectedCategory,
                    onCategorySelected: (category) {
                      productController.setCategory(category);
                    },
                  ),
                ),
              ),

              // ⭐ Featured Products Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: FadeAnimation(
                    0.3,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Featured Products',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/featured-products');
                          },
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ⭐ Featured Products List
              SliverToBoxAdapter(
                child: FadeAnimation(
                  0.4,
                  FeaturedProducts(
                    products: productController.featuredProducts,
                  ),
                ),
              ),

              // 🛒 All/Selected Products Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: FadeAnimation(
                    0.5,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          productController.selectedCategory == 'All'
                              ? 'All Products'
                              : productController.selectedCategory,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${productController.filteredProducts.length} items',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 🛍️ Product Grid
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: ProductGrid(
                  products: productController.filteredProducts,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
