import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/cart_controller.dart';
import '../models/product_model.dart';
import '../utils/animations.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String? productId;

  const ProductDetailsScreen({Key? key, this.productId}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> with SingleTickerProviderStateMixin {
  final CartController cartController = Get.find<CartController>();
  final AuthController authController = Get.find<AuthController>();
  late TabController _tabController;
  late Product product;

  String selectedSize = '';
  String selectedColor = '';
  int currentImage = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Get product from parameters
    final productId = Get.parameters['id'];
    // In a real app, you would fetch the product from your controller or API
    // For now, using a mock product
    product = Product(
      id: '1',
      name: 'Classic White T-Shirt',
      description: 'A classic white t-shirt made from 100% organic cotton. Comfortable fit and durable material for everyday wear. Features reinforced stitching at the shoulders and a relaxed neckline for added comfort.\n\nMachine washable and designed to retain its shape and color after multiple washes. This versatile piece can be dressed up with a blazer or kept casual with jeans.',
      price: 29.99,
      images: ['https://i.imgur.com/3fQnWQT.png', 'https://i.imgur.com/JhwTxRQ.png', 'https://i.imgur.com/3WIDcSZ.png'],
      rating: 4.5,
      reviews: 128,
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['#FFFFFF', '#000000', '#C4C4C4'],
      category: 'Clothing',
    );

    // Set default selections
    if (product.sizes.isNotEmpty) {
      selectedSize = product.sizes[0];
    }
    if (product.colors.isNotEmpty) {
      selectedColor = product.colors[0];
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }

  void _addToCart() {
    if (product.sizes.isNotEmpty && selectedSize.isEmpty) {
      Get.snackbar(
        'Please select a size',
        'You need to select a size before adding to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (product.colors.isNotEmpty && selectedColor.isEmpty) {
      Get.snackbar(
        'Please select a color',
        'You need to select a color before adding to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    authController.checkLoginForAction(() {
      cartController.addToCart(
        product,
        selectedSize,
        selectedColor,
      );
    });
  }

  void _buyNow() {
    if (product.sizes.isNotEmpty && selectedSize.isEmpty) {
      Get.snackbar(
        'Please select a size',
        'You need to select a size before checkout',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (product.colors.isNotEmpty && selectedColor.isEmpty) {
      Get.snackbar(
        'Please select a color',
        'You need to select a color before checkout',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    authController.checkLoginForAction(() {
      cartController.addToCart(
        product,
        selectedSize,
        selectedColor,
      );
      Get.toNamed('/checkout');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    itemCount: product.images.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentImage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Hero(
                        tag: 'product-${product.id}-${index}',
                        child: Image.network(
                          product.images[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                  if (product.images.length > 1)
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          product.images.length,
                              (index) => AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            width: currentImage == index ? 12 : 8,
                            height: currentImage == index ? 12 : 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentImage == index
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: FadeAnimation(
                          0.2,
                          Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      FadeAnimation(
                        0.3,
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  // Rating
                  FadeAnimation(
                    0.4,
                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            5,
                                (index) => Icon(
                              index < product.rating.floor()
                                  ? Icons.star
                                  : index < product.rating
                                  ? Icons.star_half
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 20,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${product.rating} (${product.reviews} reviews)',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Tab Bar
                  FadeAnimation(
                    0.5,
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Theme.of(context).primaryColor,
                        tabs: [
                          Tab(text: 'Details'),
                          Tab(text: 'Specifications'),
                          Tab(text: 'Reviews'),
                        ],
                      ),
                    ),
                  ),

                  // Tab Content
                  FadeAnimation(
                    0.6,
                    Container(
                      height: 150,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Details Tab
                          SingleChildScrollView(
                            child: Text(
                              product.description,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),

                          // Specifications Tab
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSpecItem('Material', '100% Cotton'),
                                _buildSpecItem('Weight', '180 gsm'),
                                _buildSpecItem('Care', 'Machine Washable'),
                                _buildSpecItem('Made in', 'Portugal'),
                                _buildSpecItem('Fit', 'Regular'),
                              ],
                            ),
                          ),

                          // Reviews Tab
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildReviewItem(
                                  'John D.',
                                  4.5,
                                  'Great quality t-shirt. Fits well and the material is soft.',
                                  '2 days ago',
                                ),
                                _buildReviewItem(
                                  'Sarah M.',
                                  5.0,
                                  'Perfect fit and very comfortable. Highly recommend!',
                                  '1 week ago',
                                ),
                                _buildReviewItem(
                                  'Mike L.',
                                  4.0,
                                  'Good quality for the price. Washes well.',
                                  '2 weeks ago',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Sizes
                  if (product.sizes.isNotEmpty) ...[
                    FadeAnimation(
                      0.7,
                      Text(
                        'Select Size',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    FadeAnimation(
                      0.8,
                      Wrap(
                        spacing: 12,
                        children: product.sizes.map((size) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedSize = size;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedSize == size
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey.shade300,
                                  width: selectedSize == size ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: selectedSize == size
                                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                                    : Colors.transparent,
                              ),
                              child: Center(
                                child: Text(
                                  size,
                                  style: TextStyle(
                                    fontWeight: selectedSize == size
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: selectedSize == size
                                        ? Theme.of(context).primaryColor
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],

                  // Colors
                  if (product.colors.isNotEmpty) ...[
                    FadeAnimation(
                      0.9,
                      Text(
                        'Select Color',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    FadeAnimation(
                      1.0,
                      Wrap(
                        spacing: 16,
                        children: product.colors.map((color) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedColor = color;
                              });
                            },
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _getColorFromHex(color),
                                border: Border.all(
                                  color: selectedColor == color
                                      ? Theme.of(context).primaryColor
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: [
                                  if (selectedColor == color)
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      spreadRadius: 2,
                                    ),
                                ],
                              ),
                              child: selectedColor == color
                                  ? Icon(
                                Icons.check,
                                color: _getColorFromHex(color).computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white,
                                size: 20,
                              )
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _addToCart,
                child: Text('Add to Cart'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _buyNow,
                child: Text('Buy Now'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(
      String name,
      double rating,
      String comment,
      String date,
      ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: List.generate(
              5,
                  (index) => Icon(
                index < rating.floor()
                    ? Icons.star
                    : index < rating
                    ? Icons.star_half
                    : Icons.star_border,
                color: Colors.amber,
                size: 16,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            comment,
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}