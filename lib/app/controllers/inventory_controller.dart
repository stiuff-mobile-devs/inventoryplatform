import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:inventoryplatform/app/data/models/inventory_model.dart';
import 'package:inventoryplatform/app/services/auth_service.dart';
import 'package:inventoryplatform/app/ui/device/forms/inventory_form.dart';

class InventoryController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController revisionController = TextEditingController();
  final AuthService _authService = Get.find<AuthService>();

  final isLoading = false.obs;
  late String hiveInventoryId;


  // Variável reativa para armazenar os inventários
  final RxList<InventoryModel> inventories = <InventoryModel>[].obs;

    @override
  void onInit() {
    super.onInit();
    fetchAndSaveAllInventories(); // Chama a função ao inicializar o controlador
  }

  void clearFields() {
    titleController.clear();
    descriptionController.clear();
    revisionController.clear();
  }

  Future<void> saveInventoryToFirestore(var user) async {
    try {
      CollectionReference inventories =
          FirebaseFirestore.instance.collection('inventories');
      Map<String, dynamic> data = {
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "revisionNumber": revisionController.text.trim(),
        "departament": {
          "departmentId": null, // Adicione o ID do departamento aqui
          "name": null, 
          "description departament": null,
        },
        "reports": {
          "created_at": FieldValue.serverTimestamp(),
          "created_by": user.email ?? "",
          "updated_at": "",
          "updated_by": "",
        },
        "active": true,
      };
      await inventories.doc(hiveInventoryId).set(data);
      print("Inventário salvo no Firestore com sucesso!");
    } catch (e) {
      print("Erro ao salvar Inventário: $e");
    }
  }

  Future<void> saveInventoryToHive(var user, BuildContext context) async {
    try {
      final box = Hive.box<InventoryModel>('inventories');
      final department = InventoryModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        revisionNumber: revisionController.text.trim(),
        departmentId: (context.widget as InventoryForm).cod,
        createdBy: user.email ?? "",
      );
      await box.add(department);
      hiveInventoryId = department.id;
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar inventário: $e")),
      );
    }
  }

  Future<void> saveInventory(BuildContext context) async {
    isLoading.value = true;
    var user = _authService.currentUser;
    await saveInventoryToHive(user, context);
    await saveInventoryToFirestore(user);
    clearFields();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Sucesso, inventário criado com sucesso!"),
      ),
    );
    isLoading.value = false;
    Navigator.pop(context);
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

  Future<void> fetchAndSaveAllInventories() async {
    try {
      // Referência à coleção de inventários no Firestore
      CollectionReference inventories =
          FirebaseFirestore.instance.collection('inventories');

      // Busca todos os documentos da coleção
      QuerySnapshot querySnapshot = await inventories.get();

      // Referência ao box do Hive
      final box = Hive.box<InventoryModel>('inventories');

      // Itera sobre os documentos e salva no Hive
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        final inventory = InventoryModel(
          //id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          revisionNumber: data['revisionNumber'] ?? '',
          departmentId: data['departament']?['departmentId'] ?? '',
          createdBy: data['reports']?['created_by'] ?? '',
        );

        // Salva no Hive usando o ID como chave
        await box.put(doc.id, inventory);
      }

      print("Todos os inventários foram buscados do Firestore e salvos no Hive com sucesso!");
    } catch (e) {
      print("Erro ao buscar e salvar inventários: $e");
    }
  }
}
