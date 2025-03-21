import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventoryplatform/app/controllers/department_controller.dart';

class DepartmentForm extends StatelessWidget {
  DepartmentForm({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final DepartmentController controller = Get.find<DepartmentController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Criar Novo Departamento", style: TextStyle(color: Colors.white))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.titleController,
                decoration: const InputDecoration(labelText: "Título"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "O título é obrigatório";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controller.descriptionController,
                decoration: const InputDecoration(labelText: "Descrição"),
              ),
              const SizedBox(height: 10),
              Obx(() => controller.image.value == null
                  ? const Text("Nenhuma imagem selecionada")
                  : Image.file(controller.image.value!, height: 100),),
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.saveDepartment(context);
                        }
                      },
                      child: const Text("Salvar Departamento"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
