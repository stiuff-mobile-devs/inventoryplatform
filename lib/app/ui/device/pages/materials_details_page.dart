import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inventoryplatform/app/data/models/material_model.dart';

class MaterialDetailsScreen extends StatelessWidget {
  final MaterialModel material;

  const MaterialDetailsScreen({Key? key, required this.material}) : super(key: key);

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${material.id}', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8.0),
                Text('Name: ${material.name}'),
                SizedBox(height: 8.0),
                Text('Barcode: ${material.barcode}'),
                SizedBox(height: 8.0),
                Text('Date: ${material.date.toLocal()}'),
                SizedBox(height: 8.0),
                Text('Description: ${material.description}'),
                SizedBox(height: 8.0),
                Text('Geolocation: ${material.geolocation}'),
                SizedBox(height: 8.0),
                Text('Observations: ${material.observations}'),
                SizedBox(height: 8.0),
                Text('Inventory ID: ${material.inventoryId}'),
                SizedBox(height: 8.0),
                if (material.imagePaths != null && material.imagePaths!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Images:', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.0),
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