import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inventoryplatform/app/data/models/material_model.dart';

class MaterialDetailsPage extends StatelessWidget {
  final MaterialModel material;

  const MaterialDetailsPage({Key? key, required this.material}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do material ', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
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
                          print('oi');
                        },
                        child: const Text('Criar Material'),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${material.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8.0),
                      Text('Name: ${material.name}'),
                      const SizedBox(height: 8.0),
                      Text('Barcode: ${material.barcode}'),
                      const SizedBox(height: 8.0),
                      Text('Date: ${material.date.toLocal()}'),
                      const SizedBox(height: 8.0),
                      Text('Description: ${material.description}'),
                      const SizedBox(height: 8.0),
                      Text('Geolocation: ${material.geolocation}'),
                      const SizedBox(height: 8.0),
                      Text('Observations: ${material.observations}'),
                      const SizedBox(height: 8.0),
                      Text('Inventory ID: ${material.inventoryId}'),
                      const SizedBox(height: 8.0),
                      if (material.imagePaths != null && material.imagePaths!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Images:', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8.0),
                            ...material.imagePaths!.map((path) => Image.file(File(path))).toList(),
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