import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventoryplatform/app/controllers/inventory_controller.dart';
import 'package:inventoryplatform/app/data/models/inventory_model.dart';
import 'package:inventoryplatform/app/data/models/material_model.dart';
import 'package:inventoryplatform/app/ui/device/forms/material_form.dart';

class MaterialController extends GetxController {
  
  //final _panelController = Get.find<PanelController>();
  final _inventoryController = Get.find<InventoryController>();

  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController observationsController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  Rx<File?> image = Rx<File?>(null);
  var isLoading = false.obs;
   void onClose() {
    clearData();
    super.onClose();
  }

  void clearData() {
    nameController.clear();
    descriptionController.clear();
    dateController.clear();
    barcodeController.clear();
    locationController.clear();
    observationsController.clear();
    image.value = null;
  }

  // Função para escolher ou capturar uma imagem
   Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
      update();
    }
  }

  // Função para salvar os dados no Firebase
  Future<void> saveMaterial(BuildContext context, String geolocationStr) async {
    if (barcodeController.text.isEmpty || locationController.text.isEmpty ){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos.")),
      );
      return;
    }

    try {
      final box = Hive.box<MaterialModel>('materials');
      final material = MaterialModel(
        name: nameController.text.trim(),
        barcode: barcodeController.text.trim(),
        date: DateTime.parse(dateController.text.trim()),
        description: descriptionController.text.trim(),
        geolocation: geolocationStr,
        observations: observationsController.text.trim(),
        inventoryId: (context.widget as MaterialForm).cod,
        imagePath: image.value?.path,
      );
      await box.add(material);
      // Verifique se o usuário está autenticado
     /* User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuário não autenticado.")),
        );

        return;
      }

      // Criando um nome único para a imagem
     /* String fileName = "departments/${DateTime.now().millisecondsSinceEpoch}.jpg";
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      await storageRef.putFile(_image!);
      String imageUrl = await storageRef.getDownloadURL();*/


      // Obtém a referência da coleção existente "inventories"
     String departmentId = _panelController.getCurrentOrganization()!.id; 

    // Obtendo a referência do documento do departamento específico
      DocumentReference departmentRef = FirebaseFirestore.instance
        .collection("departments")
        .doc(departmentId);

      CollectionReference inventoriesRef = departmentRef.collection("inventories");
      String inventoryId = (context.widget as MaterialForm).cod; 

      DocumentReference inventoryRef = inventoriesRef.doc(inventoryId);
      CollectionReference itemsRef = inventoryRef.collection("items");

      // Salvando no Firestore
      await itemsRef.add({
        "barcode": barcodeController.text.trim(),
        "date": dateController.text.trim(),
        "description": descriptionController.text.trim(),
        "geolocation": geolocationController.text.trim(),
        "location": locationController.text.trim(),
        "name": nameController.text.trim(),
        "observations": observations.text.trim(),
        //"image": imageUrl,
        "created_at": FieldValue.serverTimestamp(),
        "created_by": user.uid, // Adiciona o ID do usuário
      });
*/
      // Feedback de sucesso
      clearData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("material adicionado com sucesso!")),
      );

      // Voltar para a tela anterior
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar material: $e")),
      );
    }
  }

  List<MaterialModel> getMaterials() {
    final box = Hive.box<MaterialModel>('materials');
    return box.values.toList();
  }

  List<MaterialModel> getMaterialsByDepartment(String deptId) {
    final materials = getMaterials();
    final inventoryIds = getInventoriesByDept(deptId).map((inv) => inv.id).toList();
    return materials.where((mat) => inventoryIds.contains(mat.inventoryId)).toList();
  }

  List<MaterialModel> getMaterialsByInventory(String inventoryId) {
    final materials = getMaterials();
    return materials.where((mat) => mat.inventoryId == inventoryId).toList();
  }

  List<InventoryModel> getInventoriesByDept(String deptId) {
     return _inventoryController.getInventoriesByDepartment(deptId);
  }
}