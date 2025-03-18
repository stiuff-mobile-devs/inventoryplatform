import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventoryplatform/app/controllers/departments_controller.dart';

class DepartmentsForm extends StatelessWidget {
  const DepartmentsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final DepartmentsController controller = Get.find<DepartmentsController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Criar Novo Departamento")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.titleController,
              decoration: const InputDecoration(labelText: "Título"),
            ),
            TextField(
              controller: controller.descriptionController,
              decoration: const InputDecoration(labelText: "Descrição"),
            ),
            const SizedBox(height: 10),
             controller.image == null
                ? const Text("Nenhuma imagem selecionada")
                : Image.file(controller.image!, height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.camera),
                  onPressed: () => controller.pickImage(ImageSource.camera),
                ),
                IconButton(
                  icon: const Icon(Icons.photo_library),
                  onPressed: () => controller.pickImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 20),
           controller.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => controller.saveDepartment(context),
                    child: const Text("Salvar Departamento"),
                  ),
          ],
        ),
      ),
    );
  }
}
