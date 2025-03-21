import 'package:get/get.dart';
import 'package:inventoryplatform/app/controllers/department_controller.dart';

class DepartmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DepartmentController>(() => DepartmentController());
  }
}