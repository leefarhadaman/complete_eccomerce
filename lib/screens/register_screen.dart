import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../utils/animations.dart';

class RegisterScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SlideAnimation(
                  0.1,
                  Text(
                    'Join ShopEase',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 8),
                SlideAnimation(
                  0.2,
                  Text(
                    'Create an account to start shopping',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 32),
                if (authController.errorMessage.isNotEmpty)
                  SlideAnimation(
                    0.3,
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        authController.errorMessage,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ),
                SizedBox(height: 24),
                SlideAnimation(
                  0.3,
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SlideAnimation(
                  0.4,
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: 16),
                SlideAnimation(
                  0.5,
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.visibility_off),
                        onPressed: () {
                          // Toggle password visibility
                        },
                      ),
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 16),
                SlideAnimation(
                  0.6,
                  TextField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 32),
                SlideAnimation(
                  0.7,
                  ElevatedButton(
                    onPressed: authController.isLoading
                        ? null
                        : () async {
                      if (await authController.register(
                        nameController.text,
                        emailController.text,
                        passwordController.text,
                        confirmPasswordController.text,
                      )) {
                        final redirect = authController.getAndClearRedirect();
                        if (redirect['route'] != null && redirect['route'].isNotEmpty) {
                          Get.offAndToNamed(
                            redirect['route'],
                            parameters: redirect['params'],
                          );
                        } else {
                          Get.offAllNamed('/home');
                        }
                      }
                    },
                    child: authController.isLoading
                        ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Text('Create Account'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                SlideAnimation(
                  0.8,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Get.offNamed('/login');
                        },
                        child: Text('Sign In'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                SlideAnimation(
                  0.9,
                  Text(
                    'By signing up, you agree to our Terms of Service and Privacy Policy',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}