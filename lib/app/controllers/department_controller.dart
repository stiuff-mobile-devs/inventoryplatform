import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';
import 'package:inventoryplatform/app/routes/app_routes.dart';

class DepartmentController extends GetxController {
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
      /*
      //Segurança firebase
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuário não autenticado.")),
        );
        isLoading.value = false;
        return;
      }

      await FirebaseFirestore.instance.collection("departments").add({
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "created_at": FieldValue.serverTimestamp(),
        "created_by": user.uid,
      });

      mockService.addSampleOrganizations();
      */
      //SALVANDO NO BD LOCAL 
      final box = Hive.box<DepartmentModel>('departments');
      final department = DepartmentModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        imagePath: image.value?.path,
      );
      await box.add(department);

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
    }
    isLoading.value = false;
  }

  List<DepartmentModel> getDepartments() {
    final box = Hive.box<DepartmentModel>('departments');
    return box.values.toList();
  }
}