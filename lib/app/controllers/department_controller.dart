import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:inventoryplatform/app/controllers/sync_controller.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';
import 'package:inventoryplatform/app/routes/app_routes.dart';
import 'package:inventoryplatform/app/services/connection_service.dart';

class DepartmentController extends GetxController {
  final box = Hive.box<DepartmentModel>('departments');

  final SyncController syncController = SyncController();
  final ConnectionService connectionService = ConnectionService();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  Rx<File?> image = Rx<File?>(null);
  var isLoading = false.obs;

  @override
  void onClose() {
    clearData();
    super.onClose();
  }

  void clearData() {
    titleController.clear();
    descriptionController.clear();
    image.value = null;
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
      update();
    }
  }

  Future<void> saveDepartment(BuildContext context) async {
    isLoading.value = true;

    try {
      //Segurança firebase
      /*User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuário não autenticado.")),
        );
        isLoading.value = false;
        return;
      }
      */

      //SALVANDO NO BD LOCAL
      final department = DepartmentModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        imagePath: image.value?.path,
      );
      saveDepartmentToLocal(department);

      if (await connectionService.checkInternetConnection()) {
        saveDepartmentToRemote(department);
      } else {
        syncController.saveToSyncTable("departments", department.id);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Departamento criado com sucesso!")),
      );
      clearData();
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar departamento: $e")),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveDepartmentToLocal(DepartmentModel department) async {
    try {
      await box.put(department.id, department);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> saveDepartmentToRemote(DepartmentModel department) async {
    try {
      await FirebaseFirestore.instance
        .collection("departments")
        .doc(department.id)
        .set({
          "title": department.title,
          "description": department.description,
          "active": department.active,
          "created": department.created,
          "modified": department.modified
        });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> saveExistingDepartmentToLocal(String id, Map<String,dynamic> dept) async {
    DepartmentModel department = DepartmentModel.existing(
      id: id,
      title: dept['title'],
      description: dept['description'],
      active: dept['active'],
      created: dept['created'],
      modified: dept['modified']
    );

    try {
      await box.put(department.id, department);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  List<DepartmentModel> getDepartments() {
    return box.values.toList();
  }

  String? getDepartmentTitleById(String id) {
    final dept = getDepartmentById(id);
    if (dept != null) {
      return dept.title;
    }
    return null;
  }

  DepartmentModel? getDepartmentById(String id) {
    try {
      final department = box.values.firstWhere(
            (dept) => dept.id == id,
      );
      return department;
    } catch (e) {
      return null;
    }
  }
}
