class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final double rating;
  final int reviews;
  final List<String> sizes;
  final List<String> colors;
  final String category;
  final bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    this.rating = 0.0,
    this.reviews = 0,
    required this.sizes,
    required this.colors,
    required this.category,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      images: List<String>.from(json['images']),
      rating: json['rating']?.toDouble() ?? 0.0,
      reviews: json['reviews'] ?? 0,
      sizes: List<String>.from(json['sizes'] ?? []),
      colors: List<String>.from(json['colors'] ?? []),
      category: json['category'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}