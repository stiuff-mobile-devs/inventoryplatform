import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:inventoryplatform/app/bindings/departments_bindings.dart';
import 'package:inventoryplatform/app/bindings/home_bindings.dart';
import 'package:inventoryplatform/app/bindings/inventory_bindings.dart';
import 'package:inventoryplatform/app/bindings/panel_binding.dart';
import 'package:inventoryplatform/app/routes/app_routes.dart';
import 'package:inventoryplatform/app/ui/device/departments_form.dart';
import 'package:inventoryplatform/app/ui/device/home_page.dart';
import 'package:inventoryplatform/app/ui/device/initial_page.dart';
import 'package:inventoryplatform/app/ui/device/inventory_form_page.dart';
import 'package:inventoryplatform/app/ui/device/panel_page.dart';

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

    GetPage(
      name: Routes.INVENTORY,
      page: () => const InventoryFormPage(),
      binding: InventoryBinding(),
    ),

    GetPage(
      name: Routes.PANEL,
      page: () => const PanelPage(),
      binding: PanelBinding(),
    ),

  ];
}