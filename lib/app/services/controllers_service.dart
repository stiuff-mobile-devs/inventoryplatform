import 'package:get/get.dart';
import 'package:inventoryplatform/app/controllers/carousel_section_controller.dart';
import 'package:inventoryplatform/app/controllers/connection_controller.dart';
import 'package:inventoryplatform/app/controllers/department_controller.dart';
import 'package:inventoryplatform/app/controllers/inventory_controller.dart';
import 'package:inventoryplatform/app/controllers/login_controller.dart';
import 'package:inventoryplatform/app/controllers/material_controller.dart';
import 'package:inventoryplatform/app/controllers/panel_controller.dart';
import 'package:inventoryplatform/app/services/auth_service.dart';
import 'package:inventoryplatform/app/services/error_service.dart';

class ControllerInitializer {
  static Future<void> initialize() async {
    Get.put(AuthService());
    Get.put(DepartmentController());
    Get.put(ConnectionController());
    Get.put(CarouselSectionController());
    Get.put(InventoryController());
    Get.put(MaterialController());
    Get.put(PanelController());
    Get.put(ErrorService());
    Get.put(LoginController());
  }
}
