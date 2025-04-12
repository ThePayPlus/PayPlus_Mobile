import 'package:get/get.dart';
import 'package:payplus_mobile/app/modules/LoginPage/bindings/login_page_binding.dart';
import 'package:payplus_mobile/app/modules/LoginPage/views/login_page_view.dart';
import 'package:payplus_mobile/app/modules/SignupPage/bindings/signup_page_binding.dart';
import 'package:payplus_mobile/app/modules/SignupPage/views/signup_page_view.dart';
import 'package:payplus_mobile/app/modules/TransferPage/bindings/transfer_page_binding.dart';
import 'package:payplus_mobile/app/modules/TransferPage/views/transfer_page_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/views/setting_view.dart';
import '../modules/income/bindings/income_binding.dart';
import '../modules/income/views/income_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: _Paths.INCOME,
      page: () => const IncomeView(),
      binding: IncomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.TRANSFER,
      page: () => const TransferView(),
      binding: TransferBinding(),
    ),
  ];
}
