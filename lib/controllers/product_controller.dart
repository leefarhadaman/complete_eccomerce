import 'package:get/get.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  final RxList<Product> _products = <Product>[].obs;
  final RxList<Product> _featuredProducts = <Product>[].obs;
  final RxBool _isLoading = true.obs;
  final RxString _selectedCategory = 'All'.obs;
  final RxList<String> _categories = <String>['All', 'Clothing', 'Shoes', 'Accessories', 'Electronics'].obs;

  // Getters
  List<Product> get products => _products;
  List<Product> get featuredProducts => _featuredProducts;
  bool get isLoading => _isLoading.value;
  String get selectedCategory => _selectedCategory.value;
  List<String> get categories => _categories;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // Set selected category
  void setCategory(String category) {
    _selectedCategory.value = category;
    update();
  }

  // Get filtered products based on selected category
  List<Product> get filteredProducts {
    if (_selectedCategory.value == 'All') {
      return _products;
    }
    return _products.where((p) => p.category == _selectedCategory.value).toList();
  }

  // Mock fetch products
  Future<void> fetchProducts() async {
    _isLoading.value = true;

    try {
      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 800));

      // Mock product data
      final List<Product> mockProducts = [
        Product(
          id: '1',
          name: 'Classic White T-Shirt',
          description: 'A classic white t-shirt made from 100% organic cotton. Comfortable fit and durable material for everyday wear.',
          price: 29.99,
          images: ['https://i.imgur.com/3fQnWQT.png', 'https://i.imgur.com/JhwTxRQ.png'],
          rating: 4.5,
          reviews: 128,
          sizes: ['S', 'M', 'L', 'XL'],
          colors: ['#FFFFFF', '#000000', '#C4C4C4'],
          category: 'Clothing',
        ),
        Product(
          id: '2',
          name: 'Premium Denim Jeans',
          description: 'Premium quality denim jeans with a modern slim fit design. Features durable stitching and deep pockets.',
          price: 79.99,
          images: ['https://i.imgur.com/Z6JIyeA.png', 'https://i.imgur.com/gUV7nFX.png'],
          rating: 4.8,
          reviews: 95,
          sizes: ['30', '32', '34', '36'],
          colors: ['#0E3B73', '#000000'],
          category: 'Clothing',
        ),
        Product(
          id: '3',
          name: 'Running Sneakers',
          description: 'Lightweight running sneakers with responsive cushioning and breathable mesh upper for maximum comfort during workouts.',
          price: 119.99,
          images: ['https://i.imgur.com/IbTGCIj.png', 'https://i.imgur.com/aYQDxpB.png'],
          rating: 4.7,
          reviews: 214,
          sizes: ['7', '8', '9', '10', '11'],
          colors: ['#F5F5F5', '#FF5722', '#3F51B5'],
          category: 'Shoes',
        ),
        Product(
          id: '4',
          name: 'Wireless Headphones',
          description: 'Premium wireless headphones with active noise cancellation and 30-hour battery life. Features intuitive touch controls.',
          price: 199.99,
          images: ['https://i.imgur.com/KAijHHF.png', 'https://i.imgur.com/yV0qRmL.png'],
          rating: 4.9,
          reviews: 352,
          sizes: [],
          colors: ['#000000', '#FFFFFF', '#C4C4C4'],
          category: 'Electronics',
        ),
        Product(
          id: '5',
          name: 'Leather Wallet',
          description: 'Handcrafted genuine leather wallet with multiple card slots and RFID protection. Perfect balance of style and functionality.',
          price: 49.99,
          images: ['https://i.imgur.com/W3Dnlsd.png', 'https://i.imgur.com/7FhxDQx.png'],
          rating: 4.6,
          reviews: 87,
          sizes: [],
          colors: ['#8B4513', '#000000'],
          category: 'Accessories',
        ),
        Product(
          id: '6',
          name: 'Smartwatch',
          description: 'Feature-packed smartwatch with health tracking, notifications, and 5-day battery life. Water-resistant up to 50 meters.',
          price: 249.99,
          images: ['https://i.imgur.com/vZQRd0W.png', 'https://i.imgur.com/mNZR3qE.png'],
          rating: 4.7,
          reviews: 163,
          sizes: [],
          colors: ['#000000', '#C4C4C4', '#3F51B5'],
          category: 'Electronics',
        ),
      ];

      _products.value = mockProducts;
      _featuredProducts.value = mockProducts.where((p) => p.rating >= 4.7).toList();
      _isLoading.value = false;
    } catch (e) {
      print('Error fetching products: $e');
      _isLoading.value = false;
    }
  }

  // Search products by name
  List<Product> searchProducts(String query) {
    if (query.isEmpty) {
      return [];
    }
    return _products.where((p) =>
    p.name.toLowerCase().contains(query.toLowerCase()) ||
        p.description.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Toggle favorite status
  void toggleFavorite(String productId) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index >= 0) {
      final product = _products[index];
      final updatedProduct = Product(
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        images: product.images,
        rating: product.rating,
        reviews: product.reviews,
        sizes: product.sizes,
        colors: product.colors,
        category: product.category,
        isFavorite: !product.isFavorite,
      );

      _products[index] = updatedProduct;
      update();
    }
  }
}