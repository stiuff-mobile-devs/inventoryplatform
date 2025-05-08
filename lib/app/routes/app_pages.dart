import 'package:get/get.dart';
import 'package:inventoryplatform/app/bindings/department_bindings.dart';
import 'package:inventoryplatform/app/bindings/home_bindings.dart';
import 'package:inventoryplatform/app/bindings/inventory_bindings.dart';
import 'package:inventoryplatform/app/bindings/panel_binding.dart';
import 'package:inventoryplatform/app/routes/app_routes.dart';
import 'package:inventoryplatform/app/ui/device/forms/department_form.dart';
import 'package:inventoryplatform/app/ui/device/pages/home_page.dart';
import 'package:inventoryplatform/app/ui/device/pages/initial_page.dart';
import 'package:inventoryplatform/app/ui/device/forms/inventory_form.dart';
import 'package:inventoryplatform/app/ui/device/forms/material_form.dart';
import 'package:inventoryplatform/app/ui/device/pages/alternate_camera_page.dart';
import 'package:inventoryplatform/app/ui/device/pages/login_page.dart';
import 'package:inventoryplatform/app/ui/device/pages/panel_page.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.INITIAL,
      page: () => const InitialPage(),
    ),
    GetPage(
      name: Routes.DEPARTMENT,
      page: () => DepartmentForm(),
      binding: DepartmentBinding(),
    ),
    GetPage(
      name: Routes.INVENTORY,
      page: () => InventoryForm(cod: Get.parameters['cod']!),
      binding: InventoryBinding(),
    ),
    GetPage(
      name: Routes.PANEL,
      page: () => const PanelPage(),
      binding: PanelBinding(),
    ),
    GetPage(
      name: Routes.ALT_CAMERA,
      page: () => AlternateCameraPage(
          codDepartment: Get.parameters['codDepartment'] ?? ''),
    ),
    GetPage(
      name: Routes.MATERIAL,
      page: () => MaterialForm(
        codDepartment: Get.parameters['codDepartment']!,
        barcode: Get.parameters['barcode'],
      ),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginPage(),
    ),
  ];
}
