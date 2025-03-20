import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:inventoryplatform/app/data/models/departments_model.dart';
class DepartmentsController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  File? image;
  var isLoading = false.obs;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      image = File(pickedFile.path);
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
      final box = Hive.box<DepartmentsModel>('departments');
      final department = DepartmentsModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        imagePath: image?.path,
      );
      await box.add(department);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Departamento criado com sucesso!")),
      );
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar departamento: $e")),
      );
    }
    isLoading.value = false;
  }

  List<DepartmentsModel> getDepartments() {
    final box = Hive.box<DepartmentsModel>('departments');
    return box.values.toList();
  }
}