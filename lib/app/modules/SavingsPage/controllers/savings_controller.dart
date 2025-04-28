import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Saving {
  final String title;
  final String description;
  final int target;
  final int collected;

  Saving({
    required this.title,
    required this.description,
    required this.target,
    required this.collected,
  });
}

class SavingsController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final targetController = TextEditingController();
  final collectedController = TextEditingController();

  final savingsList = <Saving>[].obs;

  int get totalTarget => savingsList.fold(0, (sum, saving) => sum + saving.target);
  int get totalCollected => savingsList.fold(0, (sum, saving) => sum + saving.collected);

  @override
  void onInit() {
    super.onInit();
    // Contoh data awal
    savingsList.add(
      Saving(
        title: 'Liburan ke Bali',
        description: 'Tabungan untuk liburan ke Bali tahun depan',
        target: 7000000,
        collected: 2500000,
      ),
    );
    savingsList.add(
      Saving(
        title: 'Beli Laptop Baru',
        description: 'Tabungan untuk membeli laptop baru',
        target: 15000000,
        collected: 5000000,
      ),
    );
  }

  void clearInputFields() {
    titleController.clear();
    descriptionController.clear();
    targetController.clear();
    collectedController.clear();
  }

  void addNewSaving() {
    final title = titleController.text;
    final description = descriptionController.text;
    final target = int.tryParse(targetController.text) ?? 0;
    final collected = int.tryParse(collectedController.text) ?? 0;

    if (title.isNotEmpty && target > 0) {
      savingsList.add(
        Saving(
          title: title,
          description: description,
          target: target,
          collected: collected,
        ),
      );
      clearInputFields();
    }
  }

  void addToSaving(int index, int amount) {
    if (index >= 0 && index < savingsList.length && amount > 0) {
      final saving = savingsList[index];
      savingsList[index] = Saving(
        title: saving.title,
        description: saving.description,
        target: saving.target,
        collected: saving.collected + amount,
      );
    }
  }

  void deleteSaving(int index) {
    if (index >= 0 && index < savingsList.length) {
      savingsList.removeAt(index);
    }
  }

  String formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}