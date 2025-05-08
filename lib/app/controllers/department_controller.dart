import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';
import 'package:inventoryplatform/app/routes/app_routes.dart';
import 'package:inventoryplatform/app/services/auth_service.dart';
import 'package:inventoryplatform/app/services/connection_service.dart';

class DepartmentController extends GetxController {
  final ConnectionService connectionService = ConnectionService();
  final AuthService authService = AuthService();

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
          created_by: authService.currentUser!.uid);

      if (await connectionService.checkInternetConnection()) {
        saveDepartmentToRemote(department);
        saveDepartmentToLocal(department);
      } else {
        savePendingDepartment(department);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Departamento criado com sucesso!")),
      );
      clearData();
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      debugPrint(e.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar departamento: $e")),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveDepartmentToLocal(DepartmentModel department) async {
    final box = Hive.box<DepartmentModel>('departments');
    try {
      await box.put(department.id, department);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> savePendingDepartment(DepartmentModel department) async {
    final box = Hive.box<DepartmentModel>('departments-pending');
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
        "reports": {
          "created_at": department.created_at,
          "updated_at": department.updated_at,
          "created_by": department.created_by,
          "updated_by": department.updated_by
        }
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> saveExistingDepartmentToLocal(
      String id, Map<String, dynamic> dept) async {
    final reports = dept['reports'];

    DepartmentModel department = DepartmentModel.existing(
        id: id,
        title: dept['title'],
        description: dept['description'],
        active: dept['active'],
        created_at: reports['created_at'].toDate(),
        updated_at: reports['updated_at'].toDate(),
        created_by: reports['created_by'],
        updated_by: reports['updated_by']);

    saveDepartmentToLocal(department);
  }

  List<DepartmentModel> getDepartments() {
    final box = Hive.box<DepartmentModel>('departments');
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
    final box = Hive.box<DepartmentModel>('departments');
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
