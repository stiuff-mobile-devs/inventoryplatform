import 'package:get/get.dart';
import 'package:inventoryplatform/app/controllers/carousel_section_controller.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';

class HomeController extends GetxController {
  final CarouselSectionController carouselController = Get.put(CarouselSectionController());
/* final UtilsService _utilsService = UtilsService();
  final OrganizationRepository organizationRepository =
      Get.find<OrganizationRepository>();*/

  final List<DepartmentModel> departments = [
    DepartmentModel(
      id: '2',
      title: "Laboratórios",
      description: 'Um departamento para testes inicialmente vazia.',
    ),
    DepartmentModel(
      id: '1',
      title: "Embarcações",
      description: 'Um departamento de exemplo com dados fictícios.',
    ),
  ];

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