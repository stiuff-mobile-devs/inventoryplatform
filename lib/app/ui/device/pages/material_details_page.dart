import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventoryplatform/app/controllers/inventory_controller.dart';
import 'package:inventoryplatform/app/data/models/material_model.dart';

class MaterialDetailsPage extends StatelessWidget {
  final MaterialModel material;
  late final InventoryController _inventoryController;

  MaterialDetailsPage({Key? key, required this.material}) : super(key: key) {
    _inventoryController = Get.find<InventoryController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalhes do Material',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              // Exibe um diálogo ou mensagem indicando que está em desenvolvimento
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Em Desenvolvimento"),
                  content: const Text(
                      "Esta funcionalidade está em desenvolvimento."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.help_outline, color: Colors.white),
            label: const Text(
              "",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: material.id.isEmpty && material.barcode!.isEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Material não encontrado na base de dados, deseja criar um novo material?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          print('Criar Material');
                        },
                        child: const Text('Criar Material'),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID: ${material.id}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text('Nome: ${material.name}'),
                      const SizedBox(height: 8.0),
                      Text('Tag: ${material.barcode}'),
                      const SizedBox(height: 8.0),
                      Text('Data: ${material.date.toLocal()}'),
                      const SizedBox(height: 8.0),
                      Text('Descrição: ${material.description}'),
                      const SizedBox(height: 8.0),
                      Text('Geolocalização: ${material.geolocation}'),
                      const SizedBox(height: 8.0),
                      Text('Observações: ${material.observations}'),
                      const SizedBox(height: 8.0),
                      Text(
                          'Inventário: ${_inventoryController.getInventoryTitleById(material.inventoryId)}'),
                      const SizedBox(height: 16.0),
                      if (material.imagePaths != null &&
                          material.imagePaths!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Imagens:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8.0),
                            ...material.imagePaths!.map(
                              (path) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Image.file(
                                  File(path),
                                  fit: BoxFit.contain,
                                  height: 200,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
