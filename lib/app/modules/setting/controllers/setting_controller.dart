import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payplus_mobile/services/api_service.dart';
import 'package:payplus_mobile/services/settings_service.dart';

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
  final RxString errorMessage = ''.obs;
  final RxBool isError = false.obs;
  final RxString phoneNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
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

  // Ambil data profile dari API
  Future<void> loadUserProfile() async {
    isLoading.value = true;
    try {
      final result = await ApiService.getProfile();
      if (result['success']) {
        final data = result['data'];
        fullNameController.text = data['name'];
        emailController.text = data['email'];
        phoneNumber.value = data['phone'];
      } else {
        setErrorMessage(result['message'] ?? 'Failed to load profile');
      }
    } catch (e) {
      setErrorMessage('Error loading profile: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
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
        //Cek apakah ingin ganti password atau tidak
        final bool isChangingPassword =
            currentPasswordController.text.isNotEmpty &&
                newPasswordController.text.isNotEmpty &&
                confirmPasswordController.text.isNotEmpty;
        // Validasi password ketika ingin mengganti password
        if (isChangingPassword) {
          if (newPasswordController.text != confirmPasswordController.text) {
            setErrorMessage('New passwords do not match');
            isLoading.value = false;
            return;
          }
        }
        // Update settings dan cek apakah user ingin ganti password juga
        final result = await SettingsService.updateSettings(
            name: fullNameController.text,
            email: emailController.text,
            currentPassword:
                isChangingPassword ? currentPasswordController.text : null,
            newPassword:
                isChangingPassword ? newPasswordController.text : null);
        if (result['success']) {
          // Hapus formfield password jika sudah diupdate
          if (isChangingPassword) {
            currentPasswordController.clear();
            newPasswordController.clear();
            confirmPasswordController.clear();
          }
          setSuccessMessage(
              result['message'] ?? 'Profile updated successfully');
        } else {
          setErrorMessage(result['message'] ?? 'Failed to update profile');
        }
      } catch (e) {
        setErrorMessage('Error: ${e.toString()}');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
