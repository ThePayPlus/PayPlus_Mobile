import 'package:get/get.dart';
import 'package:payplus_mobile/app/routes/app_pages.dart';

class HomeController extends GetxController {
  // For bottom navigation
  final selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
    // Handle navigation if needed
    if (index == 0) {
      // Navigate to settings when home is clicked
    } else if (index == 2) {
      // Navigate to profile/settings
      // Get.toNamed(Routes.SETTING);
      Get.toNamed(Routes.SETTING);
    } else if (index == 1) {
      // Navigate to chatbot
      // Get.toNamed(Routes.CHATBOT);
      Get.toNamed(Routes.BILLS);
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
