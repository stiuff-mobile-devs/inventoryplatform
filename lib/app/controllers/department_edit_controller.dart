import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';
import 'package:hive/hive.dart';

class DepartmentEditController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();

  Rx<File?> image = Rx<File?>(null);

  var isEditing = false.obs;
  void toggleEditing() {
    isEditing.value = !isEditing.value;
  }

  void setInitialData(DepartmentModel department) {
    titleController.text = department.title;
    descriptionController.text = department.description;
    image.value =
        department.imagePath != null ? File(department.imagePath!) : null;
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedImage = await imagePicker.pickImage(source: source);
    image.value = pickedImage != null ? File(pickedImage.path) : null;
    debugPrint('pickedImage: ${pickedImage?.path}');
  }

  void removeImage() {
    debugPrint('removeImage');
    image.value = null;
  }

  void cancelEditing(DepartmentModel department) {
    titleController.text = department.title;
    descriptionController.text = department.description;
    toggleEditing();
  }

  void saveChanges(DepartmentModel department, BuildContext context) async {
    if (titleController.text.isEmpty) {
      Get.snackbar('Error', 'O título é obrigatório');
      return;
    }

    final box = Hive.box<DepartmentModel>('departments');

    final dp = box.values.firstWhere((dept) => dept.id == department.id,
        orElse: () => throw Exception('Departamento não encontrado'));

    dp.title = titleController.text;
    dp.description = descriptionController.text;
    dp.imagePath = image.value?.path;
    await dp.save();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Departamento atualizado com sucesso!!")),
    );

    toggleEditing();
  }
}
