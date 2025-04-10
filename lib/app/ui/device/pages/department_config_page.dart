import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventoryplatform/app/controllers/department_controller.dart';
import 'package:inventoryplatform/app/controllers/department_edit_controller.dart';
import 'package:inventoryplatform/app/controllers/panel_controller.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';

class DepartmentConfigPage extends StatefulWidget {
  const DepartmentConfigPage({super.key});
  @override
  State<DepartmentConfigPage> createState() => _DepartmentConfigPageState();
}

class _DepartmentConfigPageState extends State<DepartmentConfigPage> {
  final DepartmentEditController editController =
      Get.put(DepartmentEditController());

  late final PanelController _panelController;
  final DepartmentController controller = Get.find<DepartmentController>();

  Widget _showDepartment(DepartmentModel department) {
    return Padding(
        padding:
            const EdgeInsets.only(bottom: 25, top: 25, left: 16, right: 16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 16.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        department.title,
                        style: const TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      department.description.isNotEmpty
                          ? Column(
                              children: [
                                const Text(
                                  "Descrição:",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(department.description,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black87,
                                    )),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _image(editController.imagePath.value),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
              onPressed: () {
                editController.toggleEditing();
              },
              label: const Text('Editar Departamento'),
              icon: const Icon(Icons.edit),
            )
          ],
        ));
  }

  Widget _editingDepartment() {
    return Padding(
        padding:
            const EdgeInsets.only(bottom: 20, top: 20, left: 16, right: 16),
        child: Column(
          children: [
            TextFormField(
              controller: editController.titleController,
              decoration: InputDecoration(
                labelText: "Título",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "O título é obrigatório";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: editController.descriptionController,
              decoration: InputDecoration(
                labelText: "Descrição",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _image(editController.imagePath.value),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          editController.pickImage(ImageSource.camera),
                      child: const Icon(Icons.camera),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          editController.pickImage(ImageSource.gallery),
                      child: const Icon(Icons.photo_library),
                    ),
                    ElevatedButton(
                      onPressed: () => {
                        setState(() {
                          editController.removeImage();
                        })
                      },
                      child: const Icon(Icons.no_photography_outlined),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      editController.saveChanges(DepartmentModel(
                          title: editController.titleController.toString(),
                          description:
                              editController.descriptionController.toString()));
                    });
                  },
                  label: const Text('Salvar'),
                  icon: const Icon(Icons.save_rounded),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    editController.toggleEditing();
                  },
                  label: const Text('Cancelar'),
                  icon: const Icon(Icons.cancel),
                ),
              ],
            )
          ],
        ));
  }

  Widget _image(String imagePath) {
    return SizedBox(
        child: Center(
            child: (imagePath.isNotEmpty)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      File(imagePath),
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.black,
                    ),
                  )));
  }

  @override
  void initState() {
    super.initState();
    _panelController = Get.find<PanelController>();
  }

  Widget build(BuildContext context) {
    editController.setInitialData(_panelController.getCurrentDepartment()!);
    final department = _panelController.getCurrentDepartment()!;

    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            editController.isEditing.value
                ? _editingDepartment()
                : _showDepartment(department),
          ],
        ));
  }
}
