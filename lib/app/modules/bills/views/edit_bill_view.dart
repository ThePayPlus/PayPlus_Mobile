import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bill_controller.dart';
import '../../../data/models/bill_model.dart';

class EditBillView extends GetView<BillController> {
  const EditBillView({super.key});

  @override
  Widget build(BuildContext context) {
    final Bill bill = Get.arguments as Bill;

    // Populate the form with the bill data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.populateFormForEdit(bill);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Bill'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Bill Name',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Amount',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Due Date',
                ),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: Get.context!,
                    initialDate:
                        controller.selectedDate.value ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );

                  if (pickedDate != null) {
                    controller.setSelectedDate(pickedDate);
                  }
                },
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: () {
                    // Call the edit bill method
                    controller.editBill(
                      bill.id,
                      controller.nameController.text,
                      double.parse(controller.amountController.text),
                      controller.selectedDate.value!,
                      controller.selectedCategory.value,
                    );

                    // Show success message
                    Get.snackbar(
                      'Success',
                      'Bill updated successfully',
                      backgroundColor: Colors.green.shade100,
                      colorText: Colors.green.shade900,
                    );

                    // Go back to the bills page
                    Get.back();
                  },
                  child: const Text('Save Changes',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
