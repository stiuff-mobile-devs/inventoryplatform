import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/instance_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventoryplatform/app/controllers/department_controller.dart';
import 'package:inventoryplatform/app/controllers/panel_controller.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';

class DepartmentConfigPage extends StatefulWidget {
  const DepartmentConfigPage({super.key});
  @override
  State<DepartmentConfigPage> createState() => _DepartmentConfigPageState();
}

class _DepartmentConfigPageState extends State<DepartmentConfigPage> {
  late final PanelController _panelController;
  final DepartmentController controller = Get.find<DepartmentController>();
  bool isEditing = false;

  Widget _header(String departmentName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 20, left: 16, right: 16),
      child: !isEditing
          ? Text(
              departmentName,
              style: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            )
          : TextFormField(
              initialValue: departmentName,
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
    );
  }

  Widget _description(String departmentDescription) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 5, left: 16, right: 16),
      child: !isEditing
          ? Text(departmentDescription,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ))
          : TextFormField(
              initialValue: departmentDescription,
              decoration: InputDecoration(
                labelText: "Descrição",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              maxLines: 3,
            ),
    );
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

  Widget _info(DepartmentModel department) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(department.title),
        _description(department.description),
        !isEditing
            ? _image(department.imagePath ?? '')
            : Column(
                children: [
                  _image(department.imagePath ?? ''),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () =>
                            controller.pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera),
                        label: const Text("Câmera"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () =>
                            controller.pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library),
                        label: const Text("Galeria"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => {
                          setState(() {
                            debugPrint('Removendo Imagem');
                          })
                        },
                        icon: const Icon(Icons.no_photography_outlined),
                        label: const Text("Remover"),
                      ),
                    ],
                  ),
                ],
              ),
        Center(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: !isEditing
                    ? ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            isEditing = !isEditing;
                          });
                        },
                        label: const Text('Editar Departamento'),
                        icon: const Icon(Icons.edit),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Em Desenvolvimento"),
                                    content: const Text(
                                        "Esta funcionalidade está em desenvolvimento."),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  ),
                                );
                              });
                            },
                            label: const Text('Salvar'),
                            icon: const Icon(Icons.save_rounded),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                isEditing = !isEditing;
                              });
                            },
                            label: const Text('Cancelar'),
                            icon: const Icon(Icons.cancel),
                          ),
                        ],
                      )))
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _panelController = Get.find<PanelController>();
  }

  Widget build(BuildContext context) {
    return Container(
      child: _info(_panelController.getCurrentDepartment()!),
    );
  }
}
