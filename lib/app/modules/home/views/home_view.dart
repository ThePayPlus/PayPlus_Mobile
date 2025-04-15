import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:payplus_mobile/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  // Define consistent colors
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color primaryDarkColor = Color(0xFF4B0082);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color dangerColor = Color(0xFFFF6B6B);
  static const Color textDarkColor = Color(0xFF1F2937);
  static const Color textMediumColor = Color(0xFF666666);
  static const Color bgColor = Color(0xFFF9FAFB);
  static const Color cardColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Image.asset(
          'assets/images/Logo-PayPlus.png',
          height: 40,
        ),
        centerTitle: true,
        backgroundColor: cardColor,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: primaryColor,
                    child: const Text(
                      'JD',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          fontSize: 14,
                          color: textMediumColor,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'John Doe',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textDarkColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_outlined,
                          color: primaryColor),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Total Balance Card
            _buildTotalBalanceCard(),
            const SizedBox(height: 24),

            // Quick Actions
            _buildQuickActions(),
            const SizedBox(height: 24),

            // Income & Expense Records Sections
            _buildRecordsSections(),
            const SizedBox(height: 24),

            // Recent Transactions
            _buildRecentTransactions(),

            // Add bottom padding to account for bottom nav bar
            const SizedBox(height: 60),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: BottomNavigationBar(
              currentIndex: controller.selectedIndex.value,
              onTap: controller.changeTabIndex,
              selectedItemColor: primaryColor,
              unselectedItemColor: const Color(0xFFA0A0A0),
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 11,
              ),
              type: BottomNavigationBarType.fixed,
              backgroundColor: cardColor,
              elevation: 0,
              items: [
                _buildBottomNavItem(Icons.home_rounded, 'Home'),
                _buildBottomNavItem(Icons.chat_bubble_rounded, 'Chatbot'),
                _buildBottomNavItem(Icons.person_rounded, 'Profile'),
              ],
            ),
          ),
        ));
  }

  BottomNavigationBarItem _buildBottomNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(icon),
      ),
      label: label,
    );
  }

  Widget _buildTotalBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryColor, primaryDarkColor],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Balance',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Rp. 5,000,000',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: cardColor,
                  foregroundColor: primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Text(
                  'Top Up',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildBalanceInfoGradient(
                    'Income', 'Rp. 2,500,000', Icons.arrow_upward),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildBalanceInfoGradient(
                    'Expense', 'Rp. 1,500,000', Icons.arrow_downward),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceInfoGradient(String label, String amount, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 16,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            '$label: $amount',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textDarkColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildQuickActionButton(
              icon: Icons.send,
              label: 'Send',
              onTap: () => Get.toNamed(Routes.TRANSFER),
            ),
            _buildQuickActionButton(
              icon: Icons.account_balance_wallet,
              label: 'Top Up',
              onTap: () {},
            ),
            _buildQuickActionButton(
              icon: Icons.history,
              label: 'History',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildQuickActionButton(
              icon: Icons.savings,
              label: 'Savings',
              onTap: () => Get.toNamed(Routes.SAVINGS),
            ),
            _buildQuickActionButton(
              icon: Icons.receipt_long,
              label: 'Bills',
              onTap: () => Get.toNamed(Routes.BILLS),
            ),
            _buildQuickActionButton(
              icon: Icons.star,
              label: 'Social',
              onTap: () => Get.toNamed(Routes.FRIEND_PAGE),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 85,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: primaryColor,
                size: 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: textMediumColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordsSections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Financial Records',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textDarkColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildRecordCard(
                title: 'Income Records',
                amount: 'Rp. 4,500,000',
                icon: Icons.arrow_upward_rounded,
                iconColor: const Color(0xFF4CAF50),
                onTap: () => Get.toNamed(Routes.INCOME),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildRecordCard(
                title: 'Expense Records',
                amount: 'Rp. 2,800,000',
                icon: Icons.arrow_downward_rounded,
                iconColor: const Color(0xFFFF6B6B),
                onTap: () => Get.toNamed(Routes.OUTCOME),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecordCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textDarkColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              amount,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 12,
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    // Create sample transaction data
    final List<Map<String, dynamic>> transactions = [
      {
        'icon': Icons.shopping_bag,
        'title': 'Shopping',
        'date': 'Today, 14:30',
        'amount': 'Rp. 150,000',
        'isExpense': true,
      },
      {
        'icon': Icons.attach_money,
        'title': 'Salary',
        'date': 'Today, 09:15',
        'amount': 'Rp. 3,500,000',
        'isExpense': false,
      },
      {
        'icon': Icons.fastfood,
        'title': 'Food & Beverage',
        'date': 'Yesterday, 19:45',
        'amount': 'Rp. 85,000',
        'isExpense': true,
      },
      {
        'icon': Icons.card_giftcard,
        'title': 'Gift from John',
        'date': 'Yesterday, 11:20',
        'amount': 'Rp. 200,000',
        'isExpense': false,
      },
      {
        'icon': Icons.home,
        'title': 'Rent Payment',
        'date': '20 Jul 2023',
        'amount': 'Rp. 1,200,000',
        'isExpense': true,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textDarkColor,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'See All',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return _buildTransactionItem(
              icon: transaction['icon'],
              title: transaction['title'],
              date: transaction['date'],
              amount: transaction['isExpense']
                  ? '-${transaction['amount']}'
                  : '+${transaction['amount']}',
              isExpense: transaction['isExpense'],
            );
          },
        ),
      ],
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required String title,
    required String date,
    required String amount,
    required bool isExpense,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isExpense
                    ? [dangerColor, dangerColor.withOpacity(0.8)]
                    : [successColor, successColor.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textDarkColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: textMediumColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isExpense
                  ? dangerColor.withOpacity(0.1)
                  : successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              amount,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isExpense ? dangerColor : successColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
