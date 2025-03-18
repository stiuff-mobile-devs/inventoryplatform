import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:inventoryplatform/app/bindings/departments_bindings.dart';
import 'package:inventoryplatform/app/bindings/home_bindings.dart';
import 'package:inventoryplatform/app/routes/app_routes.dart';
import 'package:inventoryplatform/app/ui/device/departments_form.dart';
import 'package:inventoryplatform/app/ui/device/home_page.dart';
import 'package:inventoryplatform/app/ui/device/initial_page.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
 
    GetPage(
      name: Routes.INITIAL,
      page: () => InitialPage(),
    ),

    GetPage(
      name: Routes.DEPARTMENT,
      page: () => const DepartmentsForm(),
      binding: DepartmentsBinding(),
    ),

  ];
}