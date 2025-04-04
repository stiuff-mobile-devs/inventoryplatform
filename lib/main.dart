import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:inventoryplatform/app/routes/app_pages.dart';
import 'package:inventoryplatform/app/routes/app_routes.dart';
import 'package:inventoryplatform/app/services/controllers_service.dart';
import 'package:inventoryplatform/app/services/hive_service.dart';
import 'package:inventoryplatform/app/ui/device/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ControllerInitializer.initialize(); // Inicializa os controladores
  await HiveInitializer
      .initialize(); // Inicializa o Hive e registra os adapters

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
