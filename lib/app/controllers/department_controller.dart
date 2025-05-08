import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:inventoryplatform/app/controllers/image_controller.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';
import 'package:inventoryplatform/app/routes/app_routes.dart';
import 'package:inventoryplatform/app/services/auth_service.dart';
import 'package:inventoryplatform/app/services/connection_service.dart';
import 'package:inventoryplatform/app/ui/device/theme/custom_bd_dialogs.dart';
import 'package:path_provider/path_provider.dart';

class DepartmentController extends GetxController {
  final ConnectionService connectionService = ConnectionService();
  final AuthService authService = AuthService();
  final ImageController _imageController = ImageController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker picker = ImagePicker();


  Rx<File?> image = Rx<File?>(null);
  var isLoading = false.obs;


  @override
  void onClose() {
    clearData();
    super.onClose();
  }

  void clearData() {
    titleController.clear();
    descriptionController.clear();
    image.value = null;
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
      update();
    }
  }

  Future<void> saveDepartment(BuildContext context) async {
    isLoading.value = true;

    try {

      if (image.value == null) {
        final byteData =
          await rootBundle.load('assets/images/DepartamentoGenerico.jpg');
          final tempDir = await getTemporaryDirectory();
          final tempFile = File('${tempDir.path}/DepartamentoGenerico.jpg');
          await tempFile.writeAsBytes(byteData.buffer.asUint8List());
          image.value = tempFile;
    }
    
      bool firestoreSuccess = false;
      bool hiveSuccess = false;

      final department = DepartmentModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        imagePath: image.value?.path,
        created_by: authService.currentUser!.email ?? "E-mail não encontrado",
      );

      CustomDialogs.showLoadingDialog("Carregando informações para o banco remoto...");
      if (await connectionService.checkInternetConnection()) {

         try {
          await Future.delayed(const Duration(seconds: 2)); // Garante 2 segundos de exibição
          await saveDepartmentToRemote(department);
          firestoreSuccess = true;
          CustomDialogs.closeDialog(); // Fecha o pop-up anterior
          CustomDialogs.showSuccessDialog("Dados salvos remotamente com sucesso!");
          await Future.delayed(const Duration(seconds: 2));
        } catch (e) {
          CustomDialogs.closeDialog(); // Fecha o pop-up anterior
          CustomDialogs.showErrorDialog("Erro ao enviar para o banco remoto!");
          await Future.delayed(const Duration(seconds: 2));
        }

        CustomDialogs.showLoadingDialog("Carregando informações para o banco local...");

        try {
          await Future.delayed(const Duration(seconds: 2)); // Garante 2 segundos de exibição
          await saveDepartmentToLocal(department);
          hiveSuccess = true;
          CustomDialogs.closeDialog(); // Fecha o pop-up anterior
          CustomDialogs.showSuccessDialog("Dados salvos localmente com sucesso!");
          await Future.delayed(const Duration(seconds: 2));
        } catch (e) {
          CustomDialogs.closeDialog(); // Fecha o pop-up anterior
          CustomDialogs.showErrorDialog("Erro ao enviar para o banco local!");
          await Future.delayed(const Duration(seconds: 2));
        }

        CustomDialogs.closeDialog(); // Fecha o pop-up anterior

        if (firestoreSuccess && hiveSuccess) {
          CustomDialogs.showSuccessDialog("Dados enviados com sucesso!");
        } else if (firestoreSuccess || hiveSuccess) {
          CustomDialogs.showInfoDialog(
            firestoreSuccess
                ? "Apenas os dados do banco remoto foram enviados!"
                : "Apenas os dados do banco local foram enviados!",
          );
        } else {
          CustomDialogs.showErrorDialog("Erro ao enviar os dados!");
        }

        await Future.delayed(const Duration(seconds: 2));
        CustomDialogs.closeDialog(); // Fecha o pop-up final

      } else {
        CustomDialogs.closeDialog(); // Fecha o pop-up final
        CustomDialogs.showErrorDialog("Não há conexão com a internet!");
        CustomDialogs.closeDialog(); 
        savePendingDepartment(department);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Departamento criado com sucesso!")),
      );
      clearData();
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar departamento: $e")),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveDepartmentToLocal(DepartmentModel department) async {
    final box = Hive.box<DepartmentModel>('departments');
    try {
      await box.put(department.id, department);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> savePendingDepartment(DepartmentModel department) async {
    final box = Hive.box<DepartmentModel>('departments-pending');
    try {
      await box.put(department.id, department);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> saveDepartmentToRemote(DepartmentModel department) async {
    try {
      List<String> imagem =
          await _imageController.convertImagesToBase64([image.value]);
      await FirebaseFirestore.instance
        .collection("departments")
        .doc(department.id)
        .set({
          "title": department.title,
          "description": department.description,
          "active": department.active,
          "imageURL": imagem[0],
          "reports": {
            "created_at": department.created_at,
            "updated_at": department.updated_at,
            "created_by": department.created_by,
            "updated_by": department.updated_by
          }
        });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> saveExistingDepartmentToLocal(String id, Map<String,dynamic> dept, List<String> imagem) async {
    final reports = dept['reports'];

    DepartmentModel department = DepartmentModel.existing(
      id: id,
      title: dept['title'],
      description: dept['description'],
      active: dept['active'],
      created_at: reports['created_at'].toDate(),
      updated_at: reports['updated_at'].toDate(),
      created_by: reports['created_by'],
      updated_by: reports['updated_by'],
      imagePath: imagem[0],
    );

    saveDepartmentToLocal(department);
  }

  List<DepartmentModel> getDepartments() {
    final box = Hive.box<DepartmentModel>('departments');
    return box.values.toList();
  }

  String? getDepartmentTitleById(String id) {
    final dept = getDepartmentById(id);
    if (dept != null) {
      return dept.title;
    }
    return null;
  }

  DepartmentModel? getDepartmentById(String id) {
    final box = Hive.box<DepartmentModel>('departments');
    try {
      final department = box.values.firstWhere(
            (dept) => dept.id == id,
      );
      return department;
    } catch (e) {
      return null;
    }
  }
}
