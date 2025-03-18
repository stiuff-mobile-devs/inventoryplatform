import 'package:get/get.dart';
import 'package:inventoryplatform/app/controllers/carrousel_section_controller.dart';
import 'package:inventoryplatform/app/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.put(CarouselSectionController());
  }
}