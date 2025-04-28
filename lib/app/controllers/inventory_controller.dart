import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:inventoryplatform/app/controllers/sync_controller.dart';
import 'package:inventoryplatform/app/data/models/inventory_model.dart';
import 'package:inventoryplatform/app/services/connection_service.dart';
import 'package:inventoryplatform/app/ui/device/forms/inventory_form.dart';

class InventoryController extends GetxController {
  final box = Hive.box<InventoryModel>('inventories');

  final SyncController syncController = SyncController();
  final ConnectionService connectionService = ConnectionService();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController revisionController = TextEditingController();

  final isLoading = false.obs;

  // Variável reativa para armazenar os inventários
  final RxList<InventoryModel> inventories= <InventoryModel>[].obs;

  void clearFields() {
    titleController.clear();
    descriptionController.clear();
    revisionController.clear();
  }

  Future<void> saveInventory(BuildContext context) async {
    if (titleController.text.isEmpty || revisionController.text.isEmpty) {
      Get.snackbar("Erro", "Preencha o campo título e número de revisão.");
      return;
    }

    isLoading.value = true;
    try {
/* // Segurança firebase
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar("Erro", "Usuário não autenticado.");
        isLoading.value = false;
        return;
      }

      String departmentId = (context.widget as InventoryForm).cod;

      DocumentReference departmentRef = FirebaseFirestore.instance
          .collection("departments")
          .doc(departmentId);

      DocumentReference newInventoryRef = await departmentRef.collection("inventories").add({
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "revision_number": revisionController.text.trim(),
        "created_at": FieldValue.serverTimestamp(),
        "created_by": user.uid,
      });

      // Adiciona o inventário criado à lista listedItems do PanelController
      InventoryModel newInventory = InventoryModel(
        id: newInventoryRef.id,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        revisionNumber: revisionController.text.trim(),
        createdAt: DateTime.now(),
        isActive: 1,
      );
      _panelController.listedItems.add(newInventory);

      // Salva o inventário no banco de dados local
      await _dbHelper.insert('inventories', newInventory.toMap());*/
     /* // Segurança firebase
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar("Erro", "Usuário não autenticado.");
        isLoading.value = false;
        return;
      }

      String departmentId = (context.widget as InventoryForm).cod;

      DocumentReference departmentRef = FirebaseFirestore.instance
          .collection("departments")
          .doc(departmentId);

      DocumentReference newInventoryRef = await departmentRef.collection("inventories").add({
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "revision_number": revisionController.text.trim(),
        "created_at": FieldValue.serverTimestamp(),
        "created_by": user.uid,
      });

      // Adiciona o inventário criado à lista listedItems do PanelController
      InventoryModel newInventory = InventoryModel(
        id: newInventoryRef.id,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        revisionNumber: revisionController.text.trim(),
        createdAt: DateTime.now(),
        isActive: 1,
      );
      _panelController.listedItems.add(newInventory);

      // Salva o inventário no banco de dados local
      await _dbHelper.insert('inventories', newInventory.toMap());*/
      InventoryModel inventory = await _saveInventoryToLocal((context.widget as InventoryForm).cod);

      if (await connectionService.checkInternetConnection()) {
        saveInventoryToRemote(inventory);
      } else {
        syncController.saveToSyncTable("inventories", inventory.id);
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

  Future<InventoryModel> _saveInventoryToLocal(String deptId) async {
    try {
      final inventory = InventoryModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        revisionNumber: revisionController.text.trim(),
        departmentId: deptId,
      );

      await box.put(inventory.id, inventory);
      return inventory;
    }  catch (e) {
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
          "created": inventory.created,
          "modified": inventory.modified
        });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> saveExistingInventoryToLocal(String id, Map<String,dynamic> inv) async {
    InventoryModel inventory = InventoryModel.existing(
      id: id,
      title: inv['title'],
      description: inv['description'],
      revisionNumber: inv['revisionNumber'],
      departmentId: inv['departmentId'],
      active: inv['active'],
      created: inv['created'],
      modified: inv['modified']
    );

    try {
      await box.put(inventory.id, inventory);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void loadInventories() {
    inventories.assignAll(getInventories());
  }

  List<InventoryModel> getInventories() {
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
