import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventoryplatform/app/controllers/materials_controller.dart';
import 'package:intl/intl.dart'; // Import the intl package

class MaterialsForm extends StatefulWidget {
  late final String cod;
  final String? barcode;

  MaterialsForm({required this.cod, this.barcode});
  
  @override
  _MaterialsFormState createState() => _MaterialsFormState();
}

class _MaterialsFormState extends State<MaterialsForm> {
  final MaterialsController controller = Get.find<MaterialsController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.barcode != null) {
      controller.barcodeController.text = widget.barcode!;
    }
    // Set the current date to the dateController
    controller.dateController.text = DateFormat('yyyy/MM/dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Criar Novo Material", style: TextStyle(color: Colors.white),),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.barcodeController,
                decoration: const InputDecoration(labelText: "Código de Barras"),
              ),
               TextFormField(
                controller: controller.geolocationController,
                decoration: const InputDecoration(labelText: "Nome *"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controller.descriptionController,
                decoration: const InputDecoration(labelText: "Descrição *"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Descrição é obrigatória';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controller.dateController,
                decoration: const InputDecoration(labelText: "Data"),
              ),
              TextFormField(
                controller: controller.locationController,
                decoration: const InputDecoration(labelText: "Localização *"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Localização é obrigatória';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controller.observationsController,
                decoration: const InputDecoration(labelText: "Observações *"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Observações são obrigatórias';
                  }
                  return null;
                },
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
                          controller.saveMaterial(context);
                        }
                      },
                      child: const Text("Salvar Material"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

