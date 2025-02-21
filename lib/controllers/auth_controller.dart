import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final SharedPreferences prefs;

  // Observable variables
  final Rx<User?> _currentUser = Rx<User?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxString _redirectAfterLogin = ''.obs;
  final RxMap _redirectParams = {}.obs;

  // Getters
  User? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;
  bool get isLoggedIn => _currentUser.value != null;
  String get errorMessage => _errorMessage.value;

  AuthController(this.prefs) {
    loadUserFromStorage();
  }

  // Load user data from SharedPreferences
  void loadUserFromStorage() {
    final userData = prefs.getString('user');
    if (userData != null) {
      try {
        _currentUser.value = User.fromJson(jsonDecode(userData));
      } catch (e) {
        print('Error loading user data: $e');
      }
    }
  }

  // Save user data to SharedPreferences
  void _saveUserToStorage(User user) {
    prefs.setString('user', jsonEncode(user.toJson()));
  }

  // Set redirect information before login
  void setRedirectAfterLogin(String route, [Map<String, dynamic>? params]) {
    _redirectAfterLogin.value = route;
    if (params != null) {
      _redirectParams.value = params;
    }
  }

  // Get redirect info and clear it
  Map<String, dynamic> getAndClearRedirect() {
    final redirect = {
      'route': _redirectAfterLogin.value,
      'params': _redirectParams.value,
    };
    _redirectAfterLogin.value = '';
    _redirectParams.value = {};
    return redirect;
  }

  // Handle login process
  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage.value = 'Please fill in all fields';
      return false;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      // Simulate network delay
      await Future.delayed(Duration(seconds: 1));

      // Mock login - in a real app, this would be an API call
      if (email == 'user@example.com' && password == 'password') {
        final user = User(
          id: '1',
          name: 'John Doe',
          email: email,
          profileImage: 'https://randomuser.me/api/portraits/men/32.jpg',
        );

        _currentUser.value = user;
        _saveUserToStorage(user);
        _isLoading.value = false;
        return true;
      } else {
        _errorMessage.value = 'Invalid email or password';
        _isLoading.value = false;
        return false;
      }
    } catch (e) {
      _errorMessage.value = 'An error occurred. Please try again.';
      _isLoading.value = false;
      return false;
    }
  }

  // Handle registration process
  Future<bool> register(String name, String email, String password, String confirmPassword) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _errorMessage.value = 'Please fill in all fields';
      return false;
    }

    if (password != confirmPassword) {
      _errorMessage.value = 'Passwords do not match';
      return false;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      // Simulate network delay
      await Future.delayed(Duration(seconds: 1));

      // Mock registration - in a real app, this would be an API call
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
      );

      _currentUser.value = user;
      _saveUserToStorage(user);
      _isLoading.value = false;
      return true;
    } catch (e) {
      _errorMessage.value = 'An error occurred. Please try again.';
      _isLoading.value = false;
      return false;
    }
  }

  // Handle logout
  void logout() {
    _currentUser.value = null;
    prefs.remove('user');
  }

  // Check if user needs to login for specific action
  void checkLoginForAction(VoidCallback onContinue) {
    if (isLoggedIn) {
      onContinue();
    } else {
      Get.toNamed('/login');
    }
  }
}