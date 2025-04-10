import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';

class DepartmentEditController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  final RxString imagePath = ''.obs;

  var isEditing = false.obs;
  void toggleEditing() {
    isEditing.value = !isEditing.value;
  }

  void setInitialData(DepartmentModel department) {
    titleController.text = department.title ?? '';
    descriptionController.text = department.description ?? '';
    imagePath.value = department.imagePath ?? '';
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedImage = await imagePicker.pickImage(source: source);
    imagePath.value = pickedImage?.path ?? '';
  }

  void removeImage() {
    imagePath.value = '';
  }

  void cancelEditing(DepartmentModel department) {
    titleController.text = department.title;
    descriptionController.text = department.description;
    imagePath.value = department.imagePath ?? '';
    toggleEditing();
  }

  void saveChanges(DepartmentModel department) {
    if (titleController.text.isEmpty) {
      Get.snackbar('Error', 'O título é obrigatório');
      return;
    }

    debugPrint("Departamento salvo:");
    debugPrint("Título: ${titleController.text}");
    debugPrint("Descrição: ${descriptionController.text}");
    debugPrint("Imagem: ${imagePath.value}");

    Get.snackbar("Sucesso", "Departamento salvo com sucesso!");

    toggleEditing();
  }
}
