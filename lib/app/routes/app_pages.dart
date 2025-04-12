import 'package:get/get.dart';
import '../modules/bills/bindings/bill_binding.dart';
import '../modules/bills/views/bill_view.dart';
import '../modules/bills/views/edit_bill_view.dart'; // Add this import
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.BILLS; // Changed to start with bills page for testing

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.BILLS,
      page: () => const BillView(),
      binding: BillBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_BILL,
      page: () => const EditBillView(),
      binding: BillBinding(),
    ),
  ];
}
