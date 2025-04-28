import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/savings_controller.dart';

// Hapus definisi kelas Saving di sini karena sudah diimpor dari controller

class SavingsPage extends GetView<SavingsController> {
  const SavingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: const Text(
            'Savings Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () =>
                Get.offAllNamed('/home'), // Navigate to '/home' and clear history
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Obx(() => buildSummaryCard(
                      icon: Icons.attach_money,
                      title: 'Total Savings Target',
                      amount: controller.totalTarget,
                      bgColor: const Color.fromARGB(255, 225, 254, 225),
                      iconColor: const Color.fromARGB(255, 70, 186, 59),
                    )),
                const SizedBox(height: 20),
                Obx(() => buildSummaryCard(
                      icon: Icons.attach_money,
                      title: 'Savings Collected',
                      amount: controller.totalCollected,
                      bgColor: const Color.fromARGB(255, 235, 244, 255),
                      iconColor: const Color.fromARGB(255, 72, 151, 216),
                    )),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _addNewSaving,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Add New Saving',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Your Savings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.savingsList.length,
                      itemBuilder: (context, index) {
                        return buildSavingCard(
                          controller.savingsList[index],
                          index,
                          () => controller.deleteSaving(index),
                        );
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addNewSaving() {
    controller.clearInputFields();
    
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text("Add New Saving"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: controller.titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: controller.descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: controller.targetController,
                decoration: const InputDecoration(
                  labelText: "Target (e.g. 7000000)",
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: controller.collectedController,
                decoration: const InputDecoration(
                  labelText: "Collected (e.g. 500000)",
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.clearInputFields();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              controller.addNewSaving();
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void showAddToSavingDialog(int index) {
    final amountController = TextEditingController();

    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text("Add to Savings"),
        content: TextField(
          controller: amountController,
          decoration: const InputDecoration(labelText: "Amount to add"),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = int.tryParse(amountController.text) ?? 0;
              if (amount > 0) {
                controller.addToSaving(index, amount);
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  Widget buildSummaryCard({
    required IconData icon,
    required String title,
    required int amount,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: bgColor,
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color.fromARGB(255, 96, 96, 96),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                controller.formatCurrency(amount),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSavingCard(Saving saving, int index, VoidCallback onDelete) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                saving.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${((saving.collected / saving.target) * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            saving.description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: saving.collected / saving.target,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.formatCurrency(saving.collected),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Text(
                controller.formatCurrency(saving.target),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => showAddToSavingDialog(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add to Savings',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              ElevatedButton(
                onPressed: onDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
