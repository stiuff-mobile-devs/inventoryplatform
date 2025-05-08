import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:inventoryplatform/app/data/models/inventory_model.dart';
import 'package:inventoryplatform/app/services/auth_service.dart';
import 'package:inventoryplatform/app/services/connection_service.dart';
import 'package:inventoryplatform/app/ui/device/forms/inventory_form.dart';
import 'package:inventoryplatform/app/ui/device/theme/custom_bd_dialogs.dart';

class InventoryController extends GetxController {
  final ConnectionService connectionService = ConnectionService();
  final AuthService authService = AuthService();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController revisionController = TextEditingController();

  final isLoading = false.obs;

  // Variável reativa para armazenar os inventários
  final RxList<InventoryModel> inventories = <InventoryModel>[].obs;

  void clearFields() {
    titleController.clear();
    descriptionController.clear();
    revisionController.clear();
  }

  Future<void> saveInventory(BuildContext context) async {
    isLoading.value = true;
    bool firestoreSuccess = false;
    bool hiveSuccess = false;

    try {
      final inventory = InventoryModel(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          revisionNumber: revisionController.text.trim(),
          departmentId: (context.widget as InventoryForm).cod,
          created_by: authService.currentUser!.uid);
      CustomDialogs.showLoadingDialog(
          "Carregando informações para o banco remoto...");

      if (await connectionService.checkInternetConnection()) {
        try {
          await Future.delayed(
              const Duration(seconds: 2)); // Garante 2 segundos de exibição
          await saveInventoryToRemote(inventory);
          firestoreSuccess = true;
          CustomDialogs.closeDialog(); // Fecha o pop-up anterior
          CustomDialogs.showSuccessDialog(
              "Dados salvos remotamente com sucesso!");
          await Future.delayed(const Duration(seconds: 2));
        } catch (e) {
          CustomDialogs.closeDialog(); // Fecha o pop-up anterior
          CustomDialogs.showErrorDialog("Erro ao enviar para o banco remoto!");
          await Future.delayed(const Duration(seconds: 2));
        }

        CustomDialogs.showLoadingDialog(
            "Carregando informações para o banco local...");

        try {
          await Future.delayed(
              const Duration(seconds: 2)); // Garante 2 segundos de exibição
          await saveInventoryToLocal(inventory);

          hiveSuccess = true;
          CustomDialogs.closeDialog(); // Fecha o pop-up anterior
          CustomDialogs.showSuccessDialog(
              "Dados salvos localmente com sucesso!");
          await Future.delayed(const Duration(seconds: 2));
        } catch (e) {
          CustomDialogs.closeDialog(); // Fecha o pop-up anterior
          CustomDialogs.showErrorDialog("Erro ao enviar para o banco local!");
          await Future.delayed(const Duration(seconds: 2));
        }

        CustomDialogs.closeDialog(); // Fecha o pop-up anterior

        if (firestoreSuccess && hiveSuccess) {
          CustomDialogs.showSuccessDialog("Dados enviados com sucesso!");
        } else if (firestoreSuccess || hiveSuccess) {
          CustomDialogs.showInfoDialog(
            firestoreSuccess
                ? "Apenas os dados do banco remoto foram enviados!"
                : "Apenas os dados do banco local foram enviados!",
          );
        } else {
          CustomDialogs.showErrorDialog("Erro ao enviar os dados!");
        }

        await Future.delayed(const Duration(seconds: 2));
        CustomDialogs.closeDialog(); // Fecha o pop-up final
      } else {
        CustomDialogs.closeDialog(); // Fecha o pop-up final
        CustomDialogs.showErrorDialog("Não há conexão com a internet!");
        CustomDialogs.closeDialog();
        _savePendingInventory(inventory);
      }

      clearFields();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Sucesso, inventário criado com sucesso!"),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar inventário: $e")),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveInventoryToLocal(InventoryModel inventory) async {
    final box = Hive.box<InventoryModel>('inventories');
    try {
      await box.put(inventory.id, inventory);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> _savePendingInventory(InventoryModel inventory) async {
    final box = Hive.box<InventoryModel>('inventories-pending');
    try {
      await box.put(inventory.id, inventory);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> saveInventoryToRemote(InventoryModel inventory) async {
    try {
      await FirebaseFirestore.instance
          .collection("inventories")
          .doc(inventory.id)
          .set({
        "title": inventory.title,
        "description": inventory.description,
        "revisionNumber": inventory.revisionNumber,
        "departmentId": inventory.departmentId,
        "active": inventory.active,
        "reports": {
          "created_at": inventory.created_at,
          "updated_at": inventory.updated_at,
          "created_by": inventory.created_by,
          "updated_by": inventory.updated_by
        }
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> saveExistingInventoryToLocal(
      String id, Map<String, dynamic> inv) async {
    final reports = inv['reports'];

    InventoryModel inventory = InventoryModel.existing(
        id: id,
        title: inv['title'],
        description: inv['description'],
        revisionNumber: inv['revisionNumber'],
        departmentId: inv['departmentId'],
        active: inv['active'],
        created_at: reports['created_at'].toDate(),
        updated_at: reports['updated_at'].toDate(),
        created_by: reports['created_by'],
        updated_by: reports['updated_by']);

    saveInventoryToLocal(inventory);
  }

  void loadInventories() {
    inventories.assignAll(getInventories());
  }

  List<InventoryModel> getInventories() {
    final box = Hive.box<InventoryModel>('inventories');
    return box.values.toList();
  }

  List<InventoryModel> getInventoriesByDepartment(String deptId) {
    final inventories = getInventories();
    return inventories.where((item) => item.departmentId == deptId).toList();
  }

  String? getInventoryTitleById(String id) {
    final inv = getInventoryById(id);
    if (inv != null) {
      return inv.title;
    }
    return null;
  }

  InventoryModel? getInventoryById(String id) {
    final box = Hive.box<InventoryModel>('inventories');
    try {
      final inventory = box.values.firstWhere(
        (inv) => inv.id == id,
      );
      return inventory;
    } catch (e) {
      return null;
    }
  }
}
