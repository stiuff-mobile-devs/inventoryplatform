import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:inventoryplatform/app/controllers/image_controller.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';
import 'package:inventoryplatform/app/routes/app_routes.dart';
import 'package:inventoryplatform/app/services/auth_service.dart';

class DepartmentController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  final AuthService _authService = Get.find<AuthService>();
  final ImageController _imageController = Get.find<ImageController>();

  Rx<File?> image = Rx<File?>(null);
  var isLoading = false.obs;

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
      update();
    }
  }

  Future<void> saveDepartmentToFirestore(var user) async {
    try {
      await _imageController.convertImage(image.value);
      CollectionReference departments =
          FirebaseFirestore.instance.collection('departments');
      Map<String, dynamic> data = {
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "image": null,
        "reports": {
          "created_at": FieldValue.serverTimestamp(),
          "created_by": user.email ?? "",
          "updated_at": "",
          "updated_by": "",
        },
        "active": true,
        "image_url": _imageController.base64String ?? """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""",
      };
      await departments.add(data);
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
      print("Departamento salvo no Hive com sucesso!");
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> saveDepartment(BuildContext context) async {
    isLoading.value = true;
    var user = _authService.currentUser;

    await saveDepartmentToFirestore(user);
    await saveDepartmentToHive(user);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Departamento criado com sucesso!")),
    );
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
        await  _imageController.saveBase64AsImage(data['image_url']);
      final department = DepartmentModel(
       // id: doc.id,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        imagePath: _imageController.imagePath, 
        createdBy: data['reports']['created_by'] ?? '',
      );

      // Salva no Hive usando o ID como chave
      await box.put(doc.id, department);
    }
    print("Todos os departamentos foram buscados do Firestore e salvos no Hive com sucesso!");
  } catch (e) {
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
