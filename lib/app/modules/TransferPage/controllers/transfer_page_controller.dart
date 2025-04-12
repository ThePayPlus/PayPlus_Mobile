import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransferPageController extends GetxController {
  final searchController = TextEditingController();
  final amountController = TextEditingController();
  
  final RxString selectedUser = ''.obs;
  final RxString transferType = 'Normal'.obs;
  
  final List<String> transferTypes = ['Normal', 'Express', 'Scheduled'];
  
  void searchUser() {
    // Mock implementation - in a real app, this would search a database or API
    if (searchController.text.isNotEmpty) {
      selectedUser.value = 'User: Andre Aditya Amann';
      Get.snackbar('Success', 'User found!', 
        backgroundColor: Colors.green.withOpacity(0.7),
        colorText: Colors.white);
    } else {
      Get.snackbar('Error', 'Please enter a name or phone number',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white);
    }
  }
  
  void sendTransfer() {
    // Validate inputs
    if (selectedUser.value.isEmpty) {
      Get.snackbar('Error', 'Please search and select a recipient',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white);
      return;
    }
    
    if (amountController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter an amount',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white);
      return;
    }
    
    // Mock implementation - in a real app, this would call an API
    Get.snackbar('Success', 'Transfer of ${amountController.text} sent to ${selectedUser.value}',
      backgroundColor: Colors.green.withOpacity(0.7),
      colorText: Colors.white);
      
    // Reset fields after successful transfer
    searchController.clear();
    amountController.clear();
    selectedUser.value = '';
  }
  
  @override
  void onClose() {
    searchController.dispose();
    amountController.dispose();
    super.onClose();
  }
}