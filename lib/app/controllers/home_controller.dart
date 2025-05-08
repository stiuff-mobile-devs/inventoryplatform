import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventoryplatform/app/controllers/carousel_section_controller.dart';
import 'package:inventoryplatform/app/routes/app_routes.dart';

class HomeController extends GetxController {
  final CarouselSectionController carouselController =
      Get.put(CarouselSectionController());
/* final UtilsService _utilsService = UtilsService();
  final OrganizationRepository organizationRepository =
      Get.find<OrganizationRepository>();*/

  // @override
  // void onInit() {
  //   super.onInit();
  //  // fetchOrganizations();
  // }

  void createDepartment(BuildContext context) {
    Get.toNamed(Routes.DEPARTMENT);
  }

/*  void fetchOrganizations() {
    organizations.assignAll(organizationRepository.getAllOrganizations());
  }

  void joinOrganization(BuildContext context) {
    debugPrint("Participar de uma organização");
    _utilsService.showUnderDevelopmentNotice(context);
  }*/
}
