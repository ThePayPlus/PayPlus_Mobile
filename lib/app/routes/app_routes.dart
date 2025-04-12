part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const BILLS = _Paths.BILLS;
  static const EDIT_BILL = _Paths.EDIT_BILL; // Added edit bill route
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const BILLS = '/bills';
  static const EDIT_BILL = '/edit-bill'; // Added edit bill path
}
