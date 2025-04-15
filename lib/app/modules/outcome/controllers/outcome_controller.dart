import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:payplus_mobile/app/data/models/outcome_record_model.dart';

class OutcomeController extends GetxController {
  // Observable variables
  final RxList<OutcomeRecord> outcomeRecords = <OutcomeRecord>[].obs;
  final RxDouble totalOutcome = 0.0.obs;
  final RxInt totalTransactions = 0.obs;
  final RxDouble normalOutcome = 0.0.obs;
  final RxDouble giftOutcome = 0.0.obs;

  // Current filter
  final RxString currentFilter = 'all'.obs;

  // Filtered records
  final RxList<OutcomeRecord> filteredRecords = <OutcomeRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load mock data when controller initializes
    loadMockData();
  }

  // Method to load mock outcome data
  void loadMockData() {
    // Create some sample outcome records
    final mockData = [
      OutcomeRecord(
          id: 1,
          amount: 1500000,
          date: '2023-05-15',
          type: 'normal',
          receiverPhone: '081234567890',
          receiverName: 'John Doe'),
      OutcomeRecord(
          id: 2,
          amount: 500000,
          date: '2023-05-14',
          type: 'gift',
          receiverPhone: '085678901234',
          receiverName: 'Jane Smith',
          message: 'Happy birthday!'),
      OutcomeRecord(
          id: 3,
          amount: 2000000,
          date: '2023-05-12',
          type: 'normal',
          receiverPhone: '089012345678',
          receiverName: 'Bank Transfer'),
      OutcomeRecord(
          id: 4,
          amount: 750000,
          date: '2023-05-10',
          type: 'normal',
          receiverPhone: '081234567890',
          receiverName: 'John Doe'),
      OutcomeRecord(
          id: 5,
          amount: 1000000,
          date: '2023-05-08',
          type: 'gift',
          receiverPhone: '087654321098',
          receiverName: 'Sarah Connor',
          message: 'For your new project!'),
      OutcomeRecord(
          id: 6,
          amount: 3000000,
          date: '2023-05-05',
          type: 'normal',
          receiverPhone: '089012345678',
          receiverName: 'Bank Transfer'),
    ];

    // Set the outcome records
    outcomeRecords.value = mockData;

    // Calculate totals from the data
    calculateTotals();

    // Apply initial filter (all)
    applyFilter('all');
  }

  // Calculate total outcome, transactions and type-specific outcomes
  void calculateTotals() {
    double total = 0;
    double normal = 0;
    double gift = 0;

    for (var record in outcomeRecords) {
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

    totalOutcome.value = total;
    totalTransactions.value = outcomeRecords.length;
    normalOutcome.value = normal;
    giftOutcome.value = gift;
  }

  // Apply filter to outcome records
  void applyFilter(String filter) {
    currentFilter.value = filter;

    if (filter == 'all') {
      filteredRecords.value = outcomeRecords;
    } else {
      filteredRecords.value =
          outcomeRecords.where((record) => record.type == filter).toList();
    }
  }

  // Format currency to rupiah format
  String formatCurrency(double amount) {
    return 'Rp. ${amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  // Get the color for the outcome type
  Color getOutcomeTypeColor(String type) {
    switch (type) {
      case 'normal':
        return Colors.blue;
      case 'gift':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // Get the background color for the outcome type
  Color getOutcomeTypeBackgroundColor(String type) {
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