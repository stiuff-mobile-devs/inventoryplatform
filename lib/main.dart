import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';
import 'package:inventoryplatform/app/routes/app_pages.dart';
import 'package:inventoryplatform/app/routes/app_routes.dart';
import 'package:inventoryplatform/app/services/controllers_service.dart';
import 'package:inventoryplatform/app/services/hive_service.dart';
import 'package:inventoryplatform/app/ui/device/theme/app_theme.dart';
import 'package:inventoryplatform/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
 



    await HiveInitializer.initialize(); // Inicializa o Hive e registra os adapters

       //Função temporaria
    // Abre as boxes do Hive
    await Hive.openBox<DepartmentModel>('departments');
    await Hive.openBox('inventories');
    await Hive.openBox('materials');

    // Limpa os dados do Hive
    Hive.box<DepartmentModel>('departments').clear();
    Hive.box('inventories').clear();
    Hive.box('materials').clear();

    await ControllerInitializer.initialize(); // Inicializa os controladores


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
