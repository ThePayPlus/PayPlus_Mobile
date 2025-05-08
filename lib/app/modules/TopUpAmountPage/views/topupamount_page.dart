import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/topupamount_controller.dart';

class TopUpAmountPage extends StatefulWidget {
  const TopUpAmountPage({super.key});

  @override
  State<TopUpAmountPage> createState() => _TopUpAmountPageState();
}

class _TopUpAmountPageState extends State<TopUpAmountPage> {
  final TextEditingController _amountController = TextEditingController();
  final TopUpAmountController controller = Get.put(TopUpAmountController());

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            "Top Up",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(), // balik ke halaman sebelumnya
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Enter the amount you want to top up:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(top: 0, left: 0),
                      child: Text(
                        'Rp',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    hintText: '0',
                    hintStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigoAccent)
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Select Amount:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 10),
                // Tombol rekomendasi
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 2x3 layout
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.8, // Atur aspek perbandingan lebar dan tinggi
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    final amounts = [
                      'Rp25,000',
                      'Rp50,000',
                      'Rp75,000',
                      'Rp100,000',
                      'Rp200,000',
                      'Rp500,000',
                    ];
                    return _buildRecommendedAmountButton(amounts[index]);
                  },
                ),
                const SizedBox(height: 30),
                // Hapus TextField kedua untuk Account Number karena sudah ada TextField untuk amount di atas
                // Tombol Continue
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final amount = _amountController.text;
                      if (amount.isNotEmpty) {
                        // Tampilkan dialog konfirmasi sebelum melanjutkan
                        _showConfirmationDialog(amount);
                      } else {
                        Get.snackbar(
                          'Error',
                          'Please enter an amount',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6C63FF),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30)
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membuat tombol rekomendasi top up
  Widget _buildRecommendedAmountButton(String amount) {
    return ElevatedButton(
      onPressed: () {
        // Update TextField dengan nilai yang dipilih
        setState(() {
          _amountController.text = amount.replaceAll(RegExp(r'[^0-9]'), '');
 // Update value di text field
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(color: Color(0xFF6C63FF)),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        amount,
        style: TextStyle(
          color: Color(0xFF6C63FF),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi
  void _showConfirmationDialog(String amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Top Up'),
          content: Text('Are you sure you want to top up Rp $amount?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Menutup dialog jika pengguna batal
                Get.back();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Menutup dialog
                Get.back();
                
                // Panggil API untuk top up
                final result = await controller.topUp(amount);
                
                if (result['success']) {
                  _showSuccessNotification(amount);
                } else {
                  Get.snackbar(
                    'Error',
                    result['message'] ?? 'Failed to top up',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan notifikasi top up sukses
  void _showSuccessNotification(String amount) {
    Get.snackbar(
      'Top Up Success',
      'You have successfully topped up Rp $amount',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
