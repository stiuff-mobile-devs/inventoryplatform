import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventoryplatform/app/controllers/panel_controller.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';

class InventoryController extends GetxController {
  late final DepartmentModel currentDepartment;
  late final PanelController panelController;

  //**
  // 0 == Create
  // 1 == Read
  // 2 == Edit
  // */
  RxInt activeMode = 0.obs;
  dynamic initialData;

  @override
  void onInit() {
    super.onInit();
    panelController = Get.find<PanelController>();

    currentDepartment = panelController.getCurrentDepartment()!;
  }

  Future<void> submitForm(dynamic formKey) async {
    bool isFormValid = false;
    dynamic formData;
    dynamic newFormData;

    isFormValid = formKey.currentState?.submitForm() ?? false;
    formData = formKey.currentState?.inventoryModel;
    if (isFormValid) {
      //await _handleInventorySubmission(formData);
    }

    if (isFormValid) {
      panelController.refreshPage();
      debugPrint('Formulário submetido com sucesso!');
      if (activeMode.value == 2) {
        activeMode.value = 1;
      } else {
        Get.back();
      }
    } else {
      debugPrint('Erro na validação do formulário.');
    }
  }

  /*void deleteItem() {
    InventoryModel data = initialData;
    _deleteInventory(data.id);
    panelController.refreshPage();
    Get.back();
  }

  void _deleteInventory(String id) {
    organizationRepository.deleteInventoryFromOrganization(
        currentOrganization.id, id);
  }

  /*Future<void> _handleInventorySubmission(InventoryModel formData) async {
    InventoryModel? existingInventory = await organizationRepository
        .getInventoryById(currentOrganization.id, formData.id);
    if (existingInventory != null) {
      organizationRepository.updateInventoryInOrganization(
          currentOrganization.id, formData);
    } else {
      organizationRepository
          .appendInventoriesInOrganization([formData], currentOrganization.id);
    }
  }*/
  }
   */
}
