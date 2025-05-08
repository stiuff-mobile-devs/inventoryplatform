import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';
import 'package:inventoryplatform/app/data/models/inventory_model.dart';
import 'package:inventoryplatform/app/data/models/material_model.dart';

enum TabType { dashboard, inventories, materials, unknown }

class PanelController extends GetxController {
  //final _organizationRepository = Get.find<OrganizationRepository>();

  final searchController = TextEditingController();

  final Rx<DepartmentModel?> _currentDepartment = Rx<DepartmentModel?>(null);
  final RxInt selectedTabIndex = 0.obs;
  final RxList<dynamic> listedItems = <dynamic>[].obs;

  final RxList<DepartmentModel> departments = <DepartmentModel>[].obs;
  final RxList<InventoryModel> inventories = <InventoryModel>[].obs;
  final RxList<MaterialModel> materials = <MaterialModel>[].obs;
  /*final RxList<EntityModel> entities = <EntityModel>[].obs;
  final RxList<TagModel> tags = <TagModel>[].obs;
  final RxList<DomainModel> domains = <DomainModel>[].obs;
  final RxList<MemberModel> members = <MemberModel>[].obs;
  final RxList<ReaderModel> readers = <ReaderModel>[].obs;*/

  @override
  void onInit() {
    ever(selectedTabIndex, (_) => refreshPage());
    super.onInit();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void setCurrentDepartment(DepartmentModel department) {
    _currentDepartment.value = department;
  }

  DepartmentModel? getCurrentDepartment() => _currentDepartment.value;

  Future<void> refreshPage() async {
    await refreshItemsForTab(tabType: tabIndexToEnum(selectedTabIndex.value));
  }

  Future<void> refreshItemsForTab({TabType? tabType}) async {
    if (_currentDepartment.value == null) return;

    if (selectedTabIndex.value == 0) {
      await fetchAllData().then((data) => update());
    } else {
      //final deptId = _currentDepartment.value!.id;
      final dataFetchers = {
        TabType.inventories: () => {},
        TabType.materials: () => {},
      };

      if (dataFetchers.containsKey(tabType)) {
        dataFetchers[tabType]!();
      }
    }
    updateItemsBasedOnTab(selectedTabIndex.value);
  }

  Future<void> fetchAllData() async {
    final orgId = _currentDepartment.value?.id;
    if (orgId == null) return;

    /*await Future.wait([
      _fetchData(inventories,
          () => _organizationRepository.getInventoriesForOrganization(orgId)),
      _fetchData(domains,
          () => _organizationRepository.getDomainsForOrganization(orgId)),
      _fetchData(
          tags, () => _organizationRepository.getTagsForOrganization(orgId)),
      _fetchData(readers,
          () => _organizationRepository.getReadersForOrganization(orgId)),
      // _fetchData(members, () => _organizationRepository.getMembersForOrganization(orgId)),
      _fetchData(entities,
          () => _organizationRepository.getEntitiesForOrganization(orgId)),
      _fetchData(reports,
              () => _organizationRepository.getItemsForOrganization(orgId)),
    ]);*/
  }

  void updateItemsBasedOnTab(int tabIndex) {
    if (searchController.text.isNotEmpty) return;

    final tabDataMap = {
      1: inventories,
      2: materials,
    };

    listedItems.assignAll(tabDataMap[tabIndex] ?? []);
  }

  // Future<void> _fetchData<T>(
  //     RxList<T> list, Future<List<T>> Function() fetcher) async {
  //   try {
  //     list.assignAll(await fetcher());
  //   } catch (e) {
  //     list.clear();
  //     debugPrint("Erro ao buscar dados: $e");
  //   }
  // }

  TabType tabIndexToEnum(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return TabType.dashboard;
      case 1:
        return TabType.inventories;
      case 2:
        return TabType.materials;
      default:
        return TabType.unknown;
    }
  }
}
