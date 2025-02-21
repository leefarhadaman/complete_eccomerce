// File: screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../utils/animations.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        leading: IconButton(
          icon: Icon(Icons.close),
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
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 32),
                SlideAnimation(
                  0.2,
                  Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 8),
                SlideAnimation(
                  0.3,
                  Text(
                    'Sign in to your account to continue shopping',
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
                    0.4,
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
                  0.5,
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
                  0.6,
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                  ),
                ),
                SizedBox(height: 8),
                SlideAnimation(
                  0.7,
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Navigate to forgot password
                      },
                      child: Text('Forgot Password?'),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                SlideAnimation(
                  0.8,
                  ElevatedButton(
                    onPressed: authController.isLoading
                        ? null
                        : () async {
                      if (await authController.login(
                        emailController.text,
                        passwordController.text,
                      )) {
                        final redirect = authController.getAndClearRedirect();
                        if (redirect['route'] != null && redirect['route'].isNotEmpty) {
                          Get.offAndToNamed(
                            redirect['route'],
                            parameters: redirect['params'],
                          );
                        } else {
                          Get.back();
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
                        : Text('Sign In'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                SlideAnimation(
                  0.9,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?'),
                      TextButton(
                        onPressed: () {
                          Get.offNamed('/register');
                        },
                        child: Text('Sign Up'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                SlideAnimation(
                  1.0,
                  Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR CONTINUE WITH',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                SlideAnimation(
                  1.1,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton(
                        icon: Icons.g_mobiledata,
                        color: Colors.red,
                        onPressed: () {},
                      ),
                      SizedBox(width: 16),
                      _socialButton(
                        icon: Icons.facebook,
                        color: Colors.blue,
                        onPressed: () {},
                      ),
                      SizedBox(width: 16),
                      _socialButton(
                        icon: Icons.apple,
                        color: Colors.black,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _socialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Icon(
            icon,
            color: color,
            size: 32,
          ),
        ),
      ),
    );
  }
}
