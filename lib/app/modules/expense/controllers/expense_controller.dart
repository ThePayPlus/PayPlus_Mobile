import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:payplus_mobile/app/data/models/expense_record_model.dart';

class ExpenseController extends GetxController {
  // Observable variables
  final RxList<ExpenseRecord> expenseRecords = <ExpenseRecord>[].obs;
  final RxDouble totalExpense = 0.0.obs;
  final RxInt totalTransactions = 0.obs;
  final RxDouble normalExpense = 0.0.obs;
  final RxDouble giftExpense = 0.0.obs;

  // Current filter
  final RxString currentFilter = 'all'.obs;

  // Filtered records
  final RxList<ExpenseRecord> filteredRecords = <ExpenseRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load mock data when controller initializes
    loadMockData();
  }

  // Method to load mock expense data
  void loadMockData() {
    // Create some sample expense records
    final mockData = [
      ExpenseRecord(
          id: 1,
          amount: 1500000,
          date: '2023-05-15',
          type: 'normal',
          receiverPhone: '081234567890',
          receiverName: 'John Doe'),
      ExpenseRecord(
          id: 2,
          amount: 500000,
          date: '2023-05-14',
          type: 'gift',
          receiverPhone: '085678901234',
          receiverName: 'Jane Smith',
          message: 'Happy birthday!'),
      ExpenseRecord(
          id: 3,
          amount: 2000000,
          date: '2023-05-12',
          type: 'normal',
          receiverPhone: '089012345678',
          receiverName: 'Bank Transfer'),
      ExpenseRecord(
          id: 4,
          amount: 750000,
          date: '2023-05-10',
          type: 'normal',
          receiverPhone: '081234567890',
          receiverName: 'John Doe'),
      ExpenseRecord(
          id: 5,
          amount: 1000000,
          date: '2023-05-08',
          type: 'gift',
          receiverPhone: '087654321098',
          receiverName: 'Sarah Connor',
          message: 'For your new project!'),
      ExpenseRecord(
          id: 6,
          amount: 3000000,
          date: '2023-05-05',
          type: 'normal',
          receiverPhone: '089012345678',
          receiverName: 'Bank Transfer'),
    ];

    // Set the expense records
    expenseRecords.value = mockData;

    // Calculate totals from the data
    calculateTotals();

    // Apply initial filter (all)
    applyFilter('all');
  }

  // Calculate total expense, transactions and type-specific expenses
  void calculateTotals() {
    double total = 0;
    double normal = 0;
    double gift = 0;

    for (var record in expenseRecords) {
      total += record.amount;

      switch (record.type) {
        case 'normal':
          normal += record.amount;
          break;
        case 'gift':
          gift += record.amount;
          break;
      }
    }

    totalExpense.value = total;
    totalTransactions.value = expenseRecords.length;
    normalExpense.value = normal;
    giftExpense.value = gift;
  }

  // Apply filter to expense records
  void applyFilter(String filter) {
    currentFilter.value = filter;

    if (filter == 'all') {
      filteredRecords.value = expenseRecords;
    } else {
      filteredRecords.value =
          expenseRecords.where((record) => record.type == filter).toList();
    }
  }

  // Format currency to rupiah format
  String formatCurrency(double amount) {
    return 'Rp. ${amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  // Get the color for the expense type
  Color getExpenseTypeColor(String type) {
    switch (type) {
      case 'normal':
        return Colors.blue;
      case 'gift':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // Get the background color for the expense type
  Color getExpenseTypeBackgroundColor(String type) {
    switch (type) {
      case 'normal':
        return Colors.blue.shade100;
      case 'gift':
        return Colors.purple.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}