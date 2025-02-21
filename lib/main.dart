import 'package:eccomerceapp/screens/cart_screen.dart';
import 'package:eccomerceapp/screens/login_screen.dart';
import 'package:eccomerceapp/screens/product_details_screen.dart';
import 'package:eccomerceapp/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/auth_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/product_controller.dart';
import 'screens/checkout_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // Initialize controllers
  Get.put(AuthController(prefs));
  Get.put(CartController());
  Get.put(ProductController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter E-Commerce',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      defaultTransition: Transition.fadeIn,
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/product_details', page: () => ProductDetailsScreen()),
        GetPage(name: '/cart', page: () => CartScreen()),
        GetPage(name: '/checkout', page: () => CheckoutScreen()),
        GetPage(name: '/profile', page: () => ProfileScreen()),
      ],
      initialRoute: '/',
    );
  }
}
