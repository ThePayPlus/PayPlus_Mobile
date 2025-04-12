import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPageController extends GetxController {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isPasswordHidden = true.obs;
  final rememberMe = false.obs;

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void login() {
    // Validate inputs
    if (phoneController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your phone number');
      return;
    }
    
    if (passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your password');
      return;
    }
    
    // TODO: Implement actual login logic here
    // For now, just navigate to home
    Get.offAllNamed('/home');
  }

  void goToSignUp() {
    // Navigate to sign up page
    Get.toNamed('/signup-page');
  }
}
