import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: const Text(
            "Let's Top Up!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.offAllNamed(
                '/home'), // Navigate to '/home' and clear history
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
                const Text(
                  'How would you like to top up PayPlus Balance?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'BANK',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color.fromARGB(255, 107, 107, 107),
                  ),
                ),
                const SizedBox(height: 10),
                _buildBankOption(
                    '../assets/images/BRI.png', () => _showTopUpDialog('BRI')),
                _buildBankOption(
                    '../assets/images/BCA.png', () => _showTopUpDialog('BCA')),
                _buildBankOption(
                    '../assets/images/BNI.png', () => _showTopUpDialog('BNI')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBankOption(String imagePath, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            imagePath,
            height: 50,
            width: 50,
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    ),
  );
}


  void _showTopUpDialog(String bankName) {
    final TextEditingController accountController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Top Up via $bankName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: accountController,
                decoration: InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Top Up Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(), // Close dialog
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // You can handle the input values here
                String account = accountController.text;
                String amount = amountController.text;

                Get.back(); // Close dialog

                Get.snackbar(
                  'Top Up Submitted',
                  'Account: $account\nAmount: $amount',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
