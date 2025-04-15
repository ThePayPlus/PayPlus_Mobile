import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/bill_controller.dart';
import '../../../data/models/bill_model.dart';

class BillView extends GetView<BillController> {
  const BillView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Bills'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upcoming Bills',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildBillsList(),
                const SizedBox(height: 24),
                _buildAddBillForm(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBillsList() {
    return Column(
      children: controller.bills.map((bill) => _buildBillItem(bill)).toList(),
    );
  }

  Widget _buildBillItem(Bill bill) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    
    // Change the container color based on whether the bill is overdue
    final containerColor = bill.isOverdue ? Colors.red.shade50 : Colors.white;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: bill.isOverdue ? Colors.red.shade200 : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: _getIconForBill(bill),
        ),
        title: Text(bill.name),
        subtitle: Text(
          'Due on ${DateFormat('yyyy-MM-dd').format(bill.dueDate)}',
          style: TextStyle(
            color: bill.isOverdue ? Colors.red : Colors.grey,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currencyFormat.format(bill.amount),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => Get.toNamed('/edit-bill', arguments: bill),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => controller.deleteBill(bill.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getIconForBill(Bill bill) {
    IconData iconData;
    switch (bill.icon) {
      case 'home':
        iconData = Icons.home;
        break;
      case 'bolt':
        iconData = Icons.bolt;
        break;
      case 'favorite':
        iconData = Icons.favorite;
        break;
      case 'local_shipping':
        iconData = Icons.local_shipping;
        break;
      default:
        iconData = Icons.receipt;
    }
    
    return Icon(iconData);
  }

  Widget _buildAddBillForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add New Bill',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controller.nameController,
          decoration: const InputDecoration(
            hintText: 'Enter bill name',
            border: OutlineInputBorder(),
            labelText: 'Bill Name',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Enter amount bill',
            border: OutlineInputBorder(),
            labelText: 'Amount',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.dateController,
          readOnly: true,
          decoration: const InputDecoration(
            hintText: 'yyyy-mm-dd',
            border: OutlineInputBorder(),
            labelText: 'Due Date',
          ),
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: Get.context!,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2030),
            );
            
            if (pickedDate != null) {
              controller.setSelectedDate(pickedDate);
            }
          },
        ),
        const SizedBox(height: 12),
        Obx(() => DropdownButtonFormField<String>(
          value: controller.selectedCategory.value,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Category',
          ),
          items: controller.categories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              controller.selectedCategory.value = value;
            }
          },
        )),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
            ),
            onPressed: controller.submitForm,
            child: const Text('Add Bill', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}