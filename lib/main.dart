import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:inventoryplatform/app/controllers/carousel_section_controller.dart';
import 'package:inventoryplatform/app/controllers/connection_controller.dart';
import 'package:inventoryplatform/app/controllers/departments_controller.dart';
import 'package:inventoryplatform/app/controllers/inventory_controller.dart';
import 'package:inventoryplatform/app/data/models/departments_model.dart';
import 'package:inventoryplatform/app/data/models/inventories_model.dart';
import 'package:inventoryplatform/app/routes/app_pages.dart';
import 'package:inventoryplatform/app/routes/app_routes.dart';
import 'package:inventoryplatform/app/ui/device/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(DepartmentsController()); // Inicializa o controller
  Get.put(ConnectionController()); 
  Get.put(CarouselSectionController());
  Get.put(InventoryController());


  await Hive.initFlutter(); // Inicializa o Hive
  print('Hive initialized');

  Hive.registerAdapter(DepartmentsModelAdapter());
  print('DepartmentsModelAdapter registered');
  
  Hive.registerAdapter(InventoriesModelAdapter());
  print('InventoriesModelAdapter registered');

  await Hive.openBox<DepartmentsModel>('departments');
  print('Departments box opened');
  
  await Hive.openBox<InventoriesModel>('inventories');
  print('Inventories box opened');

  runApp(
    GetMaterialApp(
      title: 'Inventario',
      debugShowCheckedModeBanner: false, //Etiqueta de Debug
      getPages: AppPages.routes,
      initialRoute: Routes.INITIAL,
      theme: globalTheme,
    ),
  );
  print('App started');
}
