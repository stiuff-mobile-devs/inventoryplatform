import 'package:get/get.dart';
import 'package:inventoryplatform/app/controllers/carousel_section_controller.dart';
import 'package:inventoryplatform/app/controllers/connection_controller.dart';
import 'package:inventoryplatform/app/controllers/department_controller.dart';
import 'package:inventoryplatform/app/controllers/inventory_controller.dart';
import 'package:inventoryplatform/app/controllers/material_controller.dart';
import 'package:inventoryplatform/app/controllers/panel_controller.dart';

class ControllerInitializer {
  static void initialize() {
    Get.put(DepartmentController());
    Get.put(ConnectionController());
    Get.put(CarouselSectionController());
    Get.put(InventoryController());
    Get.put(MaterialController());
    Get.put(PanelController());
  }
}