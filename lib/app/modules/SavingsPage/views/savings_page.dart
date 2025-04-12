import 'package:flutter/material.dart';

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

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  List<Saving> savingsList = [
    Saving(
      title: "Motor",
      description: "Tabungan untuk beli motor",
      target: 7000000,
      collected: 100000,
    ),
    Saving(
      title: "Laptop",
      description: "Upgrade MacBook",
      target: 15000000,
      collected: 2000000,
    ),
    Saving(
      title: "Liburan",
      description: "Trip ke Bali",
      target: 5000000,
      collected: 2500000,
    ),
  ];

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetController = TextEditingController();
  final _collectedController = TextEditingController();

  void _addNewSaving() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Saving"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: _targetController,
                decoration: const InputDecoration(
                  labelText: "Target (e.g. 7000000)",
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _collectedController,
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
              _clearInputFields();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final title = _titleController.text;
              final desc = _descriptionController.text;
              final target = int.tryParse(_targetController.text) ?? 0;
              final collected = int.tryParse(_collectedController.text) ?? 0;

              if (title.isNotEmpty && target > 0) {
                setState(() {
                  savingsList.add(
                    Saving(
                      title: title,
                      description: desc,
                      target: target,
                      collected: collected,
                    ),
                  );
                });
                Navigator.pop(context);
                _clearInputFields();
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _clearInputFields() {
    _titleController.clear();
    _descriptionController.clear();
    _targetController.clear();
    _collectedController.clear();
  }

  void _deleteSaving(int index) {
    setState(() {
      savingsList.removeAt(index);
    });
  }

  void showAddToSavingDialog(int index) {
    final _amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add to Savings"),
        content: TextField(
          controller: _amountController,
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
              final amount = int.tryParse(_amountController.text) ?? 0;
              if (amount > 0) {
                setState(() {
                  savingsList[index] = Saving(
                    title: savingsList[index].title,
                    description: savingsList[index].description,
                    target: savingsList[index].target,
                    collected: savingsList[index].collected + amount,
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  int get totalTarget => savingsList.fold(0, (sum, item) => sum + item.target);
  int get totalCollected =>
      savingsList.fold(0, (sum, item) => sum + item.collected);

  String formatCurrency(int number) {
    return 'Rp ${number.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/logoPayplus.png', height: 40),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Savings Page',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),
                buildSummaryCard(
                  icon: Icons.attach_money,
                  title: 'Total Savings Target',
                  amount: totalTarget,
                  bgColor: const Color.fromARGB(255, 225, 254, 225),
                  iconColor: const Color.fromARGB(255, 70, 186, 59),
                ),
                const SizedBox(height: 20),
                buildSummaryCard(
                  icon: Icons.attach_money,
                  title: 'Savings Collected',
                  amount: totalCollected,
                  bgColor: const Color.fromARGB(255, 235, 244, 255),
                  iconColor: const Color.fromARGB(255, 72, 151, 216),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _addNewSaving,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Add Savings',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ...savingsList.asMap().entries.map((entry) {
                  final saving = entry.value;
                  final index = entry.key;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: buildSavingCard(saving, index, () => _deleteSaving(index)),
                  );
                }),
              ],
            ),
          ),
        ),
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
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 4,
              offset: Offset(0, 2),
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
                  formatCurrency(amount),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
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
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              saving.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              saving.description,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
            ),
            const SizedBox(height: 10),
            const Text(
              'Target',
              style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              formatCurrency(saving.target),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Amount Collected',
              style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              formatCurrency(saving.collected),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
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
      ),
    );
  }
}
