import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:payplus_mobile/app/data/models/income_record_model.dart';

class IncomeController extends GetxController {
  // Observable variables
  final RxList<IncomeRecord> incomeRecords = <IncomeRecord>[].obs;
  final RxDouble totalIncome = 0.0.obs;
  final RxInt totalTransactions = 0.obs;
  final RxDouble normalIncome = 0.0.obs;
  final RxDouble giftIncome = 0.0.obs;
  final RxDouble topupIncome = 0.0.obs;

  // Current filter
  final RxString currentFilter = 'all'.obs;

  // Filtered records
  final RxList<IncomeRecord> filteredRecords = <IncomeRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load mock data when controller initializes
    loadMockData();
  }

  // Method to load mock income data
  void loadMockData() {
    // Create some sample income records
    final mockData = [
      IncomeRecord(
          id: 1,
          amount: 1500000,
          date: '2023-05-15',
          type: 'normal',
          senderPhone: '081234567890',
          senderName: 'John Doe'),
      IncomeRecord(
          id: 2,
          amount: 500000,
          date: '2023-05-14',
          type: 'gift',
          senderPhone: '085678901234',
          senderName: 'Jane Smith',
          message: 'Happy birthday!'),
      IncomeRecord(
          id: 3,
          amount: 2000000,
          date: '2023-05-12',
          type: 'topup',
          senderPhone: '089012345678',
          senderName: 'Bank Transfer'),
      IncomeRecord(
          id: 4,
          amount: 750000,
          date: '2023-05-10',
          type: 'normal',
          senderPhone: '081234567890',
          senderName: 'John Doe'),
      IncomeRecord(
          id: 5,
          amount: 1000000,
          date: '2023-05-08',
          type: 'gift',
          senderPhone: '087654321098',
          senderName: 'Sarah Connor',
          message: 'For your new project!'),
      IncomeRecord(
          id: 6,
          amount: 3000000,
          date: '2023-05-05',
          type: 'topup',
          senderPhone: '089012345678',
          senderName: 'Bank Transfer'),
    ];

    // Set the income records
    incomeRecords.value = mockData;

    // Calculate totals from the data
    calculateTotals();

    // Apply initial filter (all)
    applyFilter('all');
  }

  // Calculate total income, transactions and type-specific incomes
  void calculateTotals() {
    double total = 0;
    double normal = 0;
    double gift = 0;
    double topup = 0;

    for (var record in incomeRecords) {
      total += record.amount;

      switch (record.type) {
        case 'normal':
          normal += record.amount;
          break;
        case 'gift':
          gift += record.amount;
          break;
        case 'topup':
          topup += record.amount;
          break;
      }
    }

    totalIncome.value = total;
    totalTransactions.value = incomeRecords.length;
    normalIncome.value = normal;
    giftIncome.value = gift;
    topupIncome.value = topup;
  }

  // Apply filter to income records
  void applyFilter(String filter) {
    currentFilter.value = filter;

    if (filter == 'all') {
      filteredRecords.value = incomeRecords;
    } else {
      filteredRecords.value =
          incomeRecords.where((record) => record.type == filter).toList();
    }
  }

  // Format currency to rupiah format
  String formatCurrency(double amount) {
    return 'Rp. ${amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  // Get the color for the income type
  Color getIncomeTypeColor(String type) {
    switch (type) {
      case 'normal':
        return Colors.blue;
      case 'gift':
        return Colors.purple;
      case 'topup':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  // Get the background color for the income type
  Color getIncomeTypeBackgroundColor(String type) {
    switch (type) {
      case 'normal':
        return Colors.blue.shade100;
      case 'gift':
        return Colors.purple.shade100;
      case 'topup':
        return Colors.amber.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}
