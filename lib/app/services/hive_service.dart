import 'package:hive_flutter/hive_flutter.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';
import 'package:inventoryplatform/app/data/models/inventory_model.dart';
import 'package:inventoryplatform/app/data/models/material_model.dart';
import 'package:inventoryplatform/app/data/models/sync_table_model.dart';

class HiveInitializer {
  static Future<void> initialize() async {
    await Hive.initFlutter(); // Inicializa o Hive
    print('Hive initialized');

    Hive.registerAdapter(DepartmentModelAdapter());
    print('DepartmentsModelAdapter registered');

    Hive.registerAdapter(InventoryModelAdapter());
    print('InventoriesModelAdapter registered');

    Hive.registerAdapter(MaterialModelAdapter());

    Hive.registerAdapter(SyncTableModelAdapter());

    await Hive.openBox<DepartmentModel>('departments');

    await Hive.openBox<InventoryModel>('inventories');

    await Hive.openBox<MaterialModel>('materials');

    await Hive.openBox<SyncTableModel>('unsynchronized');
  }
}
