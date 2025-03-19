import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventoryplatform/app/controllers/panel_controller.dart';

class PanelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PanelController>(() => PanelController());
    Get.create<CarouselController>(() => CarouselController());
  }
}
