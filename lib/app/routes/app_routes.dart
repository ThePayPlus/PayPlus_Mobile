part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const BILLS = _Paths.BILLS;
  static const EDIT_BILL = _Paths.EDIT_BILL; // Added edit bill route
  static const SETTING = _Paths.SETTING;
  static const INCOME = _Paths.INCOME;
  static const LOGIN = _Paths.LOGIN;
  static const SIGNUP = _Paths.SIGNUP;
  static const TRANSFER = _Paths.TRANSFER;
  static const TES = _Paths.TES;
  static const SAVINGS = _Paths.SAVINGS;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const BILLS = '/bills';
  static const EDIT_BILL = '/edit-bill'; // Added edit bill path
  static const SETTING = '/setting';
  static const INCOME = '/income';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const TRANSFER = '/transfer';
  static const TES = '/tes';
  static const SAVINGS = '/savings';
}
