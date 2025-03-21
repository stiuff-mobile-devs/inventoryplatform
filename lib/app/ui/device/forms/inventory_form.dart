import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventoryplatform/app/controllers/inventory_controller.dart';

class InventoryForm extends StatelessWidget {
  final InventoryController controller = Get.find<InventoryController>();
  final String cod;
  final _formKey = GlobalKey<FormState>();

  InventoryForm({required this.cod});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Criar Novo Inventário",
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
                controller: controller.titleController,
                decoration: const InputDecoration(labelText: 'Título *'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Título é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.revisionController,
                decoration: const InputDecoration(labelText: 'Número de Revisão *'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Número de Revisão é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.saveInventory(context);
                        }
                      },
                      child: const Text('Salvar Inventário'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

