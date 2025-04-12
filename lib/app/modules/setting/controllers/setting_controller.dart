import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Form controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observables
  final RxBool isLoading = false.obs;
  final RxBool isCurrentPasswordVisible = false.obs;
  final RxBool isNewPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxString userRole = 'gold'.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isError = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with mock data
    fullNameController.text = 'Fausta Akbar';
    emailController.text = 'fausta@gmail.com';
    userRole.value = 'gold';
  }

  @override
  void onClose() {
    // Dispose controllers
    fullNameController.dispose();
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Clear any error/success message
  void clearMessage() {
    errorMessage.value = '';
  }

  // Set error message
  void setErrorMessage(String message) {
    errorMessage.value = message;
    isError.value = true;
  }

  // Set success message
  void setSuccessMessage(String message) {
    errorMessage.value = message;
    isError.value = false;
  }

  // Save profile changes
  Future<void> saveChanges() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      clearMessage();

      try {
        // Mock API call delay
        await Future.delayed(const Duration(seconds: 1));

        // Password validation
        if (currentPasswordController.text.isNotEmpty ||
            newPasswordController.text.isNotEmpty ||
            confirmPasswordController.text.isNotEmpty) {
          // Check if current password is correct (mock validation)
          if (currentPasswordController.text != '123456') {
            setErrorMessage('Current password is incorrect');
            isLoading.value = false;
            return;
          }

          // Check if passwords match
          if (newPasswordController.text != confirmPasswordController.text) {
            setErrorMessage('New passwords do not match');
            isLoading.value = false;
            return;
          }
        }

        // Success
        setSuccessMessage('Profile updated successfully');

        // Clear password fields after successful update
        if (currentPasswordController.text.isNotEmpty) {
          currentPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();
        }
      } catch (e) {
        setErrorMessage('Failed to update profile: ${e.toString()}');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
