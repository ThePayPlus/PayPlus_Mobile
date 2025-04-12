import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupPageController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void register() {
    // Validate inputs
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your name');
      return;
    }
    
    if (phoneController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your phone number');
      return;
    }
    
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your email address');
      return;
    }
    
    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Error', 'Please enter a valid email address');
      return;
    }
    
    if (passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your password');
      return;
    }
    
    if (confirmPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please confirm your password');
      return;
    }
    
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }
    
    // TODO: Implement actual registration logic here
    // For now, just navigate to login
    Get.offAllNamed('/login-page');
  }

  void goToLogin() {
    Get.offAllNamed('/login-page');
  }
}