import 'package:get/get.dart';
import 'package:inventoryplatform/app/controllers/department_controller.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';

class CarouselSectionController extends GetxController {
  var carouselIndex = 0.obs;
  var isHoveredList = <bool>[].obs;

  @override
  void onInit() {
    super.onInit();
    isHoveredList.value = [];
  }

  void updateCarouselIndex(int index) {
    carouselIndex.value = index;
  }

  void setHovered(int index, bool value) {
    if (index >= 0 && index < isHoveredList.length) {
      isHoveredList[index] = value;
    }
  }

  void initializeHoverState(int itemCount) {
    isHoveredList.value = List<bool>.filled(itemCount, false);
  }


  List<DepartmentModel> getDepartments() {
    final departmentsController = Get.find<DepartmentController>();
    return departmentsController.getDepartments();
  }
}