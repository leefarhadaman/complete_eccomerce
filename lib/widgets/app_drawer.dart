import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDrawer extends StatelessWidget {
  final List<CategoryModel> categories = [
    CategoryModel(
      name: 'Electronics',
      icon: Icons.devices,
      subCategories: ['Smartphones', 'Laptops', 'Accessories', 'Audio'],
    ),
    CategoryModel(
      name: 'Fashion',
      icon: Icons.checkroom,
      subCategories: ['Men', 'Women', 'Kids', 'Accessories'],
    ),
    CategoryModel(
      name: 'Home & Living',
      icon: Icons.home_filled,
      subCategories: ['Furniture', 'Decor', 'Kitchen', 'Lighting'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildHeader(),
            // _buildSearchBar(),
            _buildNavigationSection(),
            const Divider(height: 1),
            _buildCategoriesSection(),
            const Divider(height: 1),
            _buildAccountSection(),
            const Divider(height: 1),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 35, color: Colors.blue.shade700),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome!',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'John Doe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }

  Widget _buildNavigationSection() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('Home'),
          onTap: () => Get.toNamed('/home'),
        ),
        ListTile(
          leading: const Icon(Icons.local_offer_outlined),
          title: const Text('Deals'),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'New',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          onTap: () => Get.toNamed('/deals'),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return ExpansionTile(
      leading: const Icon(Icons.category_outlined),
      title: const Text('Categories'),
      children: categories.map((category) {
        return ExpansionTile(
          leading: Icon(category.icon),
          title: Text(category.name),
          children: category.subCategories.map((subCategory) {
            return ListTile(
              contentPadding: const EdgeInsets.only(left: 72),
              title: Text(subCategory),
              onTap: () => Get.toNamed('/category/$subCategory'),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildAccountSection() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.shopping_bag_outlined),
          title: const Text('My Orders'),
          onTap: () => Get.toNamed('/orders'),
        ),
        ListTile(
          leading: const Icon(Icons.favorite_border),
          title: const Text('Wishlist'),
          onTap: () => Get.toNamed('/wishlist'),
        ),
        ListTile(
          leading: const Icon(Icons.shopping_cart_outlined),
          title: const Text('Cart'),
          trailing: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '3',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          onTap: () => Get.toNamed('/cart'),
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Settings'),
          onTap: () => Get.toNamed('/settings'),
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Help & Support'),
          onTap: () => Get.toNamed('/support'),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            // Handle logout logic
            Get.offAllNamed('/login');
          },
        ),
      ],
    );
  }
}

class CategoryModel {
  final String name;
  final IconData icon;
  final List<String> subCategories;

  CategoryModel({
    required this.name,
    required this.icon,
    required this.subCategories,
  });
}