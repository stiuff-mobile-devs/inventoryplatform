import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';
import 'package:inventoryplatform/app/routes/app_routes.dart';
import 'package:inventoryplatform/app/services/auth_service.dart';

class DepartmentController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  final AuthService _authService = Get.find<AuthService>();

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

  Future<void> saveDepartmentToFirestore(var user) async {
    try {
      CollectionReference departments =
          FirebaseFirestore.instance.collection('departments');
      Map<String, dynamic> data = {
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "reports": {
          "created_at": FieldValue.serverTimestamp(),
          "created_by": user.email ?? "",
          "updated_at": "",
          "updated_by": "",
        },
        "active": true,
      };
      await departments.add(data);
      print("Departamento salvo no Firestore com sucesso!");
    } catch (e) {
      print("Erro ao salvar departamento: $e");
    }
  }

  Future<void> saveDepartmentToHive(var user) async {
    try {
      final box = Hive.box<DepartmentModel>('departments');
      final department = DepartmentModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        imagePath: image.value?.path,
        createdBy: user.email ?? "",
      );
      await box.add(department);
      print("Departamento salvo no Hive com sucesso!");
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> saveDepartment(BuildContext context) async {
    isLoading.value = true;
    var user = _authService.currentUser;

    await saveDepartmentToFirestore(user);
    await saveDepartmentToHive(user);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Departamento criado com sucesso!")),
    );
    clearData();
    Get.offAllNamed(Routes.HOME);
    isLoading.value = false;
  }

  List<DepartmentModel> getDepartments() {
    final box = Hive.box<DepartmentModel>('departments');
    return box.values.toList();
  }

  String? getDepartmentTitleById(String id) {
    final box = Hive.box<DepartmentModel>('departments');
    try {
      final department = box.values.firstWhere(
        (dept) => dept.id == id,
      );
      return department.title;
    } catch (e) {
      // Retorna null se nenhum departamento for encontrado
      return null;
    }
  }
}
