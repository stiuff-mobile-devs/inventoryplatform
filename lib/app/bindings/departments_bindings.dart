import 'package:get/get.dart';
import 'package:inventoryplatform/app/controllers/departments_controller.dart';

class DepartmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DepartmentsController>(() => DepartmentsController());
  }
}