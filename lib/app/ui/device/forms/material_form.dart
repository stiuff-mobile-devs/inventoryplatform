import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventoryplatform/app/controllers/material_controller.dart';
import 'package:intl/intl.dart';
import 'package:inventoryplatform/app/ui/device/theme/image_item.dart'; // Import the intl package

class MaterialForm extends StatefulWidget {
  late final String cod;
  final String? barcode;

  MaterialForm({required this.cod, this.barcode});

  @override
  _MaterialFormState createState() => _MaterialFormState();
}

class _MaterialFormState extends State<MaterialForm> {
  final MaterialController controller = Get.find<MaterialController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.barcode != null) {
      controller.barcodeController.text = widget.barcode!;
    }
    // Set the current date to the dateController
    controller.dateController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Criar Novo Material",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.barcodeController,
                decoration:
                    const InputDecoration(labelText: "Código de Barras"),
              ),
              TextFormField(
                controller: controller.nameController,
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
              SizedBox(
                height: 100,
                child: GetBuilder<MaterialController>(
                  builder: (controller) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return ImageItem(
                          imagePath: index < controller.images.length
                              ? controller.images[index]
                              : null,
                          onRemove: index < controller.images.length
                              ? () {
                                  controller.images.removeAt(index);
                                  controller.update();
                                }
                              : null,
                          onAddImage: index >= controller.images.length
                              ? () => controller.addImage(context)
                              : null,
                        );
                      },
                    );
                  },
                ),
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
