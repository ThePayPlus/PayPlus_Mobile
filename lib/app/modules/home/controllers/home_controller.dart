import 'package:get/get.dart';
import 'package:payplus_mobile/app/routes/app_pages.dart';
import 'package:payplus_mobile/services/api_service.dart';

class HomeController extends GetxController {
  // For bottom navigation
  final selectedIndex = 0.obs;

  // Profile data observables
  final RxString name = ''.obs;
  final RxDouble totalIncome = 0.0.obs;
  final RxDouble balance = 0.0.obs;
  final RxDouble totalExpense = 0.0.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxList<Map<String, dynamic>> recentTransactions =
      <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
    fetchRecentTransactions();
  }

  void fetchRecentTransactions() async {
    try {
      final result = await ApiService.getRecentTransactions();
      recentTransactions.assignAll(result);
    } catch (e) {
      // Handle error jika perlu
      recentTransactions.clear();
    }
  }

  void fetchProfileData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await ApiService.getProfile();
      if (result['success']) {
        final data = result['data'];
        name.value = data['name'];
        balance.value = (data['balance'] ?? 0).toDouble();
        totalIncome.value = (data['total_income'] ?? 0).toDouble();
        totalExpense.value = (data['total_expense'] ?? 0).toDouble();
      } else {
        errorMessage.value = 'Failed to load profile data';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void changeTabIndex(int index) {
    selectedIndex.value = index;
    // Handle navigation if needed
    if (index == 0) {
      // Navigate to settings when home is clicked
    } else if (index == 1) {
      // Navigate to profile/settings
      // Get.toNamed(Routes.SETTING);
      Get.toNamed(Routes.CHAT_BOT);
    } else if (index == 2) {
      // Navigate to chatbot
      // Get.toNamed(Routes.CHATBOT);
      Get.toNamed(Routes.SETTING);
    }
  }

  final count = 0.obs;

  void increment() => count.value++;
}
