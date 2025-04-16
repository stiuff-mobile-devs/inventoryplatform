import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:inventoryplatform/app/data/models/inventory_model.dart';
import 'package:inventoryplatform/app/ui/device/forms/inventory_form.dart';

class InventoryController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController revisionController = TextEditingController();

  final isLoading = false.obs;
  String? currentInventoryId;

  //final PanelController _panelController = Get.find<PanelController>();

  Future<void> saveInventory(BuildContext context) async {
    if (titleController.text.isEmpty || revisionController.text.isEmpty) {
      Get.snackbar("Erro", "Preencha o campo título e número de revisão.");
      return;
    }

    isLoading.value = true;

    try {
      final box = Hive.box<InventoryModel>('inventories');
      final department = InventoryModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        revisionNumber: revisionController.text.trim(),
        departmentId: (context.widget as InventoryForm).cod,
      );
      await box.put(department.id, department);
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

  List<InventoryModel> getInventories() {
    final box = Hive.box<InventoryModel>('inventories');

    return box.values.toList();
  }

  List<InventoryModel> getInventoriesByDepartment(String deptId) {
    final inventories = getInventories();
    return inventories.where((item) => item.departmentId == deptId).toList();
  }

  String? getInventoryTitleById(String id) {
    final box = Hive.box<InventoryModel>('inventories');
    try {
      final inventory = box.values.firstWhere(
        (inv) => inv.id == id,
      );
      return inventory.title;
    } catch (e) {
      // Retorna null se nenhum departamento for encontrado
      return null;
    }
  }

  Future<void> saveInventoryChanges(BuildContext context, String inventoryId) async {
    DateTime now = DateTime.now();

    if (inventoryId == null) {
      Get.snackbar("Erro", "Nenhum inventário selecionado para edição.");
      return;
    }

    if (titleController.text.isEmpty || revisionController.text.isEmpty) {
      Get.snackbar("Erro", "Preencha o campo título e número de revisão.");
      return;
    }

    isLoading.value = true;
    try {
      final box = Hive.box<InventoryModel>('inventories');
      final inventory = box.get(inventoryId);

      if (inventory != null) {
        inventory.title = titleController.text.trim();
        inventory.description = descriptionController.text.trim();
        inventory.revisionNumber = revisionController.text.trim();
        inventory.updatedAt = now;
        await box.put(inventoryId, inventory);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Alterações salvas com sucesso!"),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar alterações: $e")),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void loadInventoryForEdit(InventoryModel inventory, String inventoryId) {
    inventoryId = inventory.id;
    titleController.text = inventory.title;
    descriptionController.text = inventory.description ?? '';
    revisionController.text = inventory.revisionNumber ?? '0.0.1';
  }

  void clearControllers() {
    titleController.clear();
    descriptionController.clear();
    revisionController.clear();
    currentInventoryId = null;
  }
}
