import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Add this import
import '../../../data/models/bill_model.dart';

class BillController extends GetxController {
  final bills = <Bill>[].obs;
  final isLoading = false.obs;

  // Form controllers
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final categories = ['Rent', 'Utilities', 'Insurance', 'Vehicle', 'Other'];
  final selectedCategory = RxString('Rent');
  final selectedDate = Rx<DateTime?>(null);
  Timer? _notificationTimer;

  @override
  void onInit() {
    super.onInit();
    fetchBills();

    // Set up timer to check for notifications every 1 minutes
    _notificationTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      checkBillNotifications();
    });

    // Also check immediately on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkBillNotifications();
    });
  }

  @override
  void onClose() {
    _notificationTimer?.cancel();
    nameController.dispose();
    amountController.dispose();
    dateController.dispose();
    super.onClose();
  }

  void fetchBills() {
    isLoading.value = true;
    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      bills.value = [
        Bill(
          id: '1',
          name: 'Kost',
          amount: 1200000,
          dueDate: DateTime(2025, 5, 21),
          category: 'Rent',
          icon: 'home',
        ),
        Bill(
          id: '2',
          name: 'Token Listrik',
          amount: 50000,
          dueDate: DateTime(2025, 4, 24),
          category: 'Utilities',
          icon: 'bolt',
        ),
        Bill(
          id: '3',
          name: 'BPJS',
          amount: 350000,
          dueDate: DateTime(2025, 4, 30),
          category: 'Insurance',
          icon: 'favorite',
        ),
        Bill(
          id: '4',
          name: 'Motor',
          amount: 5000000,
          dueDate: DateTime(2025, 5, 12),
          category: 'Vehicle',
          icon: 'local_shipping',
        ),
      ];
      isLoading.value = false;

      // Check for overdue bills and show notifications
      checkOverdueBills();
    });
  }

  void checkOverdueBills() {
    // For demo purposes, we'll simulate overdue bills
    // In a real app, you would compare with the current date
    for (var bill in bills) {
      if (bill.isOverdue) {
        showOverdueNotification(bill);
      }
    }
  }

  void checkBillNotifications() {
    /*  final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
     */
    for (var bill in bills) {
      // Check for overdue bills
      if (bill.isOverdue) {
        showOverdueNotification(bill);
      }

      // Check for bills due tomorrow using the isDueTomorrow getter
      if (bill.isDueTomorrow) {
        showDueTomorrowNotification(bill);
      }
    }
  }

  void showDueTomorrowNotification(Bill bill) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    Get.snackbar(
      'Bill Due Tomorrow',
      'Your bill for "${bill.name}" (${currencyFormat.format(bill.amount)}) is due tomorrow!',
      backgroundColor: Colors.amber.shade100,
      colorText: Colors.amber.shade900,
      duration: const Duration(seconds: 5),
      snackPosition: SnackPosition.TOP,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      icon: const Icon(Icons.access_time, color: Colors.amber),
      mainButton: TextButton(
        onPressed: () {
          // Close the notification
          Get.back();
        },
        child: const Text('Dismiss', style: TextStyle(color: Colors.amber)),
      ),
    );
  }

  void showOverdueNotification(Bill bill) {
    Get.snackbar(
      'Overdue Bill',
      'Your bill for "${bill.name}" was due ${bill.daysOverdue} day(s) ago!',
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade900,
      duration: const Duration(seconds: 5),
      snackPosition: SnackPosition.TOP,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      icon: const Icon(Icons.warning, color: Colors.red),
    );
  }

  void addBill(String name, double amount, DateTime dueDate, String category) {
    final newBill = Bill(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      amount: amount,
      dueDate: dueDate,
      category: category,
      icon: getCategoryIcon(category),
    );

    bills.add(newBill);
    bills.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  String getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'rent':
        return 'home';
      case 'utilities':
        return 'bolt';
      case 'insurance':
        return 'favorite';
      case 'vehicle':
        return 'local_shipping';
      default:
        return 'receipt';
    }
  }

  void deleteBill(String id) {
    bills.removeWhere((bill) => bill.id == id);
  }

  // Add these methods after deleteBill method
  void editBill(String id, String name, double amount, DateTime dueDate,
      String category) {
    final index = bills.indexWhere((bill) => bill.id == id);
    if (index != -1) {
      bills[index] = Bill(
        id: id,
        name: name,
        amount: amount,
        dueDate: dueDate,
        category: category,
        icon: getCategoryIcon(category),
      );
      bills.refresh();
      bills.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    }
  }

  void populateFormForEdit(Bill bill) {
    nameController.text = bill.name;
    amountController.text = bill.amount.toString();
    selectedDate.value = bill.dueDate;
    dateController.text = DateFormat('yyyy-MM-dd').format(bill.dueDate);
    selectedCategory.value = bill.category;
  }

  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
    dateController.text = DateFormat('yyyy-MM-dd').format(date);
  }

  void clearForm() {
    nameController.clear();
    amountController.clear();
    dateController.clear();
    selectedDate.value = null;
    selectedCategory.value = categories.first;
  }

  void submitForm() {
    if (nameController.text.isNotEmpty &&
        amountController.text.isNotEmpty &&
        selectedDate.value != null) {
      addBill(
        nameController.text,
        double.parse(amountController.text),
        selectedDate.value!,
        selectedCategory.value,
      );

      clearForm();

      Get.snackbar(
        'Success',
        'Bill added successfully',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
    } else {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }
}
