import 'package:hive_flutter/hive_flutter.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';
import 'package:inventoryplatform/app/data/models/inventory_model.dart';
import 'package:inventoryplatform/app/data/models/material_model.dart';

class HiveInitializer {
  static Future<void> initialize() async {
    await Hive.initFlutter(); // Inicializa o Hive
    print('Hive initialized');

    Hive.registerAdapter(DepartmentModelAdapter());
    Hive.registerAdapter(InventoryModelAdapter());
    Hive.registerAdapter(MaterialModelAdapter());

    // Tabelas
    await Hive.openBox<DepartmentModel>('departments');
    await Hive.openBox<InventoryModel>('inventories');
    await Hive.openBox<MaterialModel>('materials');

    // Tabelas temporárias
    await Hive.openBox<DepartmentModel>('departments-pending');
    await Hive.openBox<InventoryModel>('inventories-pending');
    await Hive.openBox<MaterialModel>('materials-pending');
  }
}
