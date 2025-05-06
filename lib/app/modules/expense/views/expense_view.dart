import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/expense_controller.dart';

class ExpenseView extends GetView<ExpenseController> {
  const ExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F8),
      appBar: AppBar(
        title: const Text('Expense Records', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offAllNamed('/home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expense Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 16),

            // Expense Statistics Cards
            _buildExpenseStatsGrid(),
            const SizedBox(height: 24),

            // Expense Distribution Chart
            _buildExpenseDistributionChart(),
            const SizedBox(height: 24),

            // Recent Transactions
            _buildRecentTransactionsHeader(),
            const SizedBox(height: 16),

            // Expense Records Cards
            _buildExpenseRecordsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard(
          title: 'Total Expense',
          icon: Icons.account_balance_wallet,
          iconColor: Colors.green,
          iconBgColor: Colors.green.shade100,
          valueWidget: GetX<ExpenseController>(
            builder: (controller) => Text(
              controller.formatCurrency(controller.totalExpense.value),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ),

        // Total Transactions Card
        _buildStatCard(
          title: 'Total Transactions',
          icon: Icons.people,
          iconColor: Colors.orange,
          iconBgColor: Colors.orange.shade100,
          valueWidget: GetX<ExpenseController>(
            builder: (controller) => Text(
              controller.totalTransactions.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ),

        // Normal Expense Card
        _buildStatCard(
          title: 'Normal Expense',
          icon: Icons.pie_chart,
          iconColor: Colors.blue,
          iconBgColor: Colors.blue.shade100,
          valueWidget: GetX<ExpenseController>(
            builder: (controller) => Text(
              controller.formatCurrency(controller.normalExpense.value),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ),

        // Gift Expense Card
        _buildStatCard(
          title: 'Gift Expense',
          icon: Icons.card_giftcard,
          iconColor: Colors.purple,
          iconBgColor: Colors.purple.shade100,
          valueWidget: GetX<ExpenseController>(
            builder: (controller) => Text(
              controller.formatCurrency(controller.giftExpense.value),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Generic stat card
  Widget _buildStatCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required Widget valueWidget,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 4),
                valueWidget,
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Expense distribution chart
  Widget _buildExpenseDistributionChart() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Expense Distribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: GetX<ExpenseController>(
              builder: (controller) => PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      color: Colors.blue,
                      value: controller.normalExpense.value,
                      title: 'Normal',
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.purple,
                      value: controller.giftExpense.value,
                      title: 'Gift',
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Normal', Colors.blue),
              const SizedBox(width: 16),
              _buildLegendItem('Gift', Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  // Legend item for the pie chart
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  // Recent transactions header with filter buttons
  Widget _buildRecentTransactionsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Transactions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterButton('All', 'all'),
              const SizedBox(width: 8),
              _buildFilterButton('Normal', 'normal'),
              const SizedBox(width: 8),
              _buildFilterButton('Gift', 'gift'),
            ],
          ),
        ),
      ],
    );
  }

  // Filter button
  Widget _buildFilterButton(String label, String filterValue) {
    return GetX<ExpenseController>(
      builder: (controller) => ElevatedButton(
        onPressed: () => controller.applyFilter(filterValue),
        style: ElevatedButton.styleFrom(
          backgroundColor: controller.currentFilter.value == filterValue
              ? const Color(0xFF8E44AD)
              : Colors.grey.shade200,
          foregroundColor: controller.currentFilter.value == filterValue
              ? Colors.white
              : Colors.grey.shade700,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: controller.currentFilter.value == filterValue ? 2 : 0,
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildExpenseRecordsList() {
    return GetX<ExpenseController>(
      builder: (controller) {
        if (controller.filteredRecords.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(32),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No expense records found',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.filteredRecords.length,
          itemBuilder: (context, index) {
            final record = controller.filteredRecords[index];
            return _buildExpenseRecordCard(record);
          },
        );
      },
    );
  }

  Widget _buildExpenseRecordCard(dynamic record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.formatCurrency(record.amount),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                Text(
                  record.date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Receiver:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
                Text(
                  record.receiverName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Type:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: controller.getExpenseTypeBackgroundColor(record.type),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    record.type.substring(0, 1).toUpperCase() +
                        record.type.substring(1),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: controller.getExpenseTypeColor(record.type),
                    ),
                  ),
                ),
              ],
            ),
            if (record.type == 'gift' && record.message != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Message:',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  record.message!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}