import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payplus_mobile/services/api_service.dart';

class SignupPageController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

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

  Future<void> register() async {
    // Validate inputs
    if (nameController.text.isEmpty) {
      Get.snackbar(
        'Error', 
        'Please enter your name',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return;
    }

    if (phoneController.text.isEmpty) {
      Get.snackbar(
        'Error', 
        'Please enter your phone number',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return;
    }

    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Error', 
        'Please enter your email address',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar(
        'Error', 
        'Please enter a valid email address',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text.isEmpty) {
      Get.snackbar(
        'Error', 
        'Please enter your password',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return;
    }

    if (confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        'Error', 
        'Please confirm your password',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error', 
        'Passwords do not match',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      // Call the API service to register
      final result = await ApiService.register(
        nameController.text,
        phoneController.text,
        emailController.text,
        passwordController.text
      );
      
      if (result['success']) {
        // Registration successful
        Get.snackbar(
          'Success', 
          'Registration successful! Please login.',
          backgroundColor: Colors.green.withOpacity(0.7),
          colorText: Colors.white,
        );
        
        // Navigate to login page
        Get.offAllNamed('/login');
      } else {
        // Registration failed
        Get.snackbar(
          'Error', 
          result['message'] ?? 'Registration failed',
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Registration failed: ${e.toString()}',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() {
    Get.offAllNamed('/login');
  }
}
