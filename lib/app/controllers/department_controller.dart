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
import 'package:inventoryplatform/app/ui/device/theme/custom_bd_dialogs.dart';
import 'package:path_provider/path_provider.dart';

class DepartmentController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  final AuthService _authService = Get.find<AuthService>();
  final ImageController _imageController = Get.find<ImageController>();

  Rx<File?> image = Rx<File?>(null);
  var isLoading = false.obs;
  late String hiveDepartmentId;

  @override
  void onInit() {
    super.onInit();
    fetchAndSaveAllDepartments(); // Chama a função ao inicializar o controlador
  }

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
    }
    update();
  }

  Future<void> saveDepartmentToFirestore(var user) async {
    try {
      List<String> imagem =
          await _imageController.convertImagesToBase64([image.value]);
      CollectionReference departments =
          FirebaseFirestore.instance.collection('departments');
      Map<String, dynamic> data = {
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "reports": {
          "created_at": FieldValue.serverTimestamp(),
          "created_by": user.email ?? "",
          "updated_at": "",
          "updated_by": "",
        },
        "active": true,
        "image_url": imagem[0],
      };
      await departments.doc(hiveDepartmentId).set(data);
      print("Departamento salvo no Firestore com sucesso!");
    } catch (e) {
      print("Erro ao salvar departamento: $e");
    }
  }

  Future<void> saveDepartmentToHive(var user) async {
    try {
      final box = Hive.box<DepartmentModel>('departments');
      final department = DepartmentModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        imagePath: image.value?.path,
        createdBy: user.email ?? "",
      );
      await box.add(department); 
      hiveDepartmentId = department.id!; // Armazena o ID do departamento
      print("Departamento salvo no Hive com sucesso!");
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> saveDepartment(BuildContext context) async {
    isLoading.value = true;
    var user = _authService.currentUser;

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

    CustomDialogs.showLoadingDialog("Carregando informações para o banco local...");
    try {
      await Future.delayed(const Duration(seconds: 2)); // Garante 2 segundos de exibição
      await saveDepartmentToHive(user);
      hiveSuccess = true;
      CustomDialogs.closeDialog(); // Fecha o pop-up anterior
      CustomDialogs.showSuccessDialog("Dados salvos localmente com sucesso!");
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      CustomDialogs.closeDialog(); // Fecha o pop-up anterior
      CustomDialogs.showErrorDialog("Erro ao enviar para o banco local!");
      await Future.delayed(const Duration(seconds: 2));
    }
    // Exibe o pop-up inicial com barra de progresso
    CustomDialogs.showLoadingDialog("Carregando informações para o banco online...");
    try {
      await Future.delayed(const Duration(seconds: 2)); // Garante 2 segundos de exibição
      await saveDepartmentToFirestore(user);
      firestoreSuccess = true;
      CustomDialogs.closeDialog(); // Fecha o pop-up anterior
      CustomDialogs.showSuccessDialog("Dados salvos online com sucesso!");
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      CustomDialogs.closeDialog(); // Fecha o pop-up anterior
      CustomDialogs.showErrorDialog("Erro ao enviar para o banco online!");
      await Future.delayed(const Duration(seconds: 2));
    }
    // Exibe o resultado final
    CustomDialogs.closeDialog(); // Fecha o pop-up anterior
    if (firestoreSuccess && hiveSuccess) {
      CustomDialogs.showSuccessDialog("Dados enviados com sucesso!");
    } else if (firestoreSuccess || hiveSuccess) {
      CustomDialogs.showInfoDialog(
        firestoreSuccess
            ? "Apenas os dados do banco online foram enviados!"
            : "Apenas os dados do banco local foram enviados!",
      );
    } else {
      CustomDialogs.showErrorDialog("Erro ao enviar os dados!");
    }

    await Future.delayed(const Duration(seconds: 2));
    CustomDialogs.closeDialog(); // Fecha o pop-up final

    clearData();
    Get.offAllNamed(Routes.HOME);
    isLoading.value = false;
  }

  Future<void> fetchAndSaveAllDepartments() async {
    try {
      // Referência à coleção de departamentos no Firestore
      CollectionReference departments =
          FirebaseFirestore.instance.collection('departments');

      // Busca todos os documentos da coleção
      QuerySnapshot querySnapshot = await departments.get();

      // Referência ao box do Hive
      final box = Hive.box<DepartmentModel>('departments');

      // Itera sobre os documentos e salva no Hive
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<String> imagem =
            (await _imageController.convertBase64ToImages([data['image_url']]));
        final department = DepartmentModel(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          imagePath: imagem[0],
          createdBy: data['reports']['created_by'] ?? '',
        );

        // Salva no Hive usando o ID como chave
        await box.put(doc.id, department); //Salva ou atualiza o departamento
      }

      // Fecha o diálogo após o carregamento
      CustomDialogs.closeDialog();

      print(
          "Todos os departamentos foram buscados do Firestore e salvos no Hive com sucesso!");
    } catch (e) {
      // Fecha o diálogo em caso de erro
      CustomDialogs.closeDialog();
      print("Erro ao buscar e salvar departamentos: $e");
    }
  }

  List<DepartmentModel> getDepartments() {
    final box = Hive.box<DepartmentModel>('departments');
    return box.values.toList();
  }

  String? getDepartmentTitleById(String id) {
    final box = Hive.box<DepartmentModel>('departments');
    try {
      final department = box.values.firstWhere(
        (dept) => dept.id == id,
      );
      return department.title;
    } catch (e) {
      // Retorna null se nenhum departamento for encontrado
      return null;
    }
  }
}
