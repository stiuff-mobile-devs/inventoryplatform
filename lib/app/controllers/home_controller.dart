import 'package:get/get.dart';
import 'package:inventoryplatform/app/controllers/carrousel_section_controller.dart';

class HomeController extends GetxController {
  final CarouselSectionController carouselController = Get.put(CarouselSectionController());
/* final UtilsService _utilsService = UtilsService();
  final OrganizationRepository organizationRepository =
      Get.find<OrganizationRepository>();

  final RxList<OrganizationModel> organizations = <OrganizationModel>[].obs;*/

  @override
  void onInit() {
    super.onInit();
   // fetchOrganizations();
  }

/*  void fetchOrganizations() {
    organizations.assignAll(organizationRepository.getAllOrganizations());
  }

  void createOrganization(BuildContext context) {
    debugPrint("Criar uma nova organização");
    _utilsService.showUnderDevelopmentNotice(context);
  }

  void joinOrganization(BuildContext context) {
    debugPrint("Participar de uma organização");
    _utilsService.showUnderDevelopmentNotice(context);
  }*/
}