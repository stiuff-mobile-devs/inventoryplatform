import 'package:hive_flutter/hive_flutter.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';
import 'package:inventoryplatform/app/data/models/inventory_model.dart';
import 'package:inventoryplatform/app/data/models/material_model.dart';
import 'package:inventoryplatform/app/data/models/tag_model.dart';

class HiveInitializer {
  static Future<void> initialize() async {
    await Hive.initFlutter(); // Inicializa o Hive
    print('Hive initialized');

    Hive.registerAdapter(DepartmentModelAdapter());
    print('DepartmentsModelAdapter registered');

    Hive.registerAdapter(InventoryModelAdapter());
    print('InventoriesModelAdapter registered');

    Hive.registerAdapter(MaterialModelAdapter());
    print('MaterialsModelAdapter registered');

    Hive.registerAdapter(TagModelAdapter());
    print('TagsModelAdapter registered');

    await Hive.openBox<DepartmentModel>('departments');
    print('Departments box opened');

    await Hive.openBox<InventoryModel>('inventories');
    print('Inventories box opened');

    await Hive.openBox<MaterialModel>('materials');
    print('materials box opened');

    await Hive.openBox<TagModel>('tags');
    print('tags box opened');
  }
}
