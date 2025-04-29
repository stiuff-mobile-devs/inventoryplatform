import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventoryplatform/app/controllers/inventory_controller.dart';
import 'package:inventoryplatform/app/data/models/inventory_model.dart';
import 'package:inventoryplatform/app/data/models/material_model.dart';
import 'package:inventoryplatform/app/services/auth_service.dart';
import 'package:inventoryplatform/app/ui/device/forms/material_form.dart';
import 'package:inventoryplatform/app/ui/device/pages/material_details_page.dart';

class MaterialController extends GetxController {
  //final _panelController = Get.find<PanelController>();
  final _inventoryController = Get.find<InventoryController>();

  final TextEditingController tagController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController observationsController = TextEditingController();
  final AuthService _authService = Get.find<AuthService>();

  final ImagePicker picker = ImagePicker();

  final List<String> images = [];
  Rx<File?> image = Rx<File?>(null);

  var isLoading = false.obs;

    @override
  void onInit() {
    super.onInit();
    fetchAndSaveAllMaterials(); // Chama a função ao inicializar o controlador
  }

  void onClose() {
    clearData();
    super.onClose();
  }

  void clearData() {
    nameController.clear();
    descriptionController.clear();
    dateController.clear();
    tagController.clear();
    locationController.clear();
    observationsController.clear();
    image.value = null;
    //images.clear();
  }

  // Função para escolher ou capturar uma imagem
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
      update();
    }
  }

  Future<void> addImage(BuildContext context) async {
    if (images.length < 3) {
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Escolha a origem da imagem'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () {
                  Navigator.pop(context, ImageSource.camera);
                },
                tooltip: 'Câmera',
              ),
              IconButton(
                icon: const Icon(Icons.photo_library),
                onPressed: () {
                  Navigator.pop(context, ImageSource.gallery);
                },
                tooltip: 'Galeria',
              ),
            ],
          );
        },
      );

      if (source != null) {
        final XFile? image = await picker.pickImage(source: source);
        if (image != null) {
          images.add(image.path);
          update();
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Máximo de 3 imagens atingido.')),
      );
    }
  }

  Future<dynamic> checkMaterial(String tag) async {
    var box = await Hive.openBox<MaterialModel>('materials');

    // Cria um material vazio
    MaterialModel material = MaterialModel(
        name: '',
        tag: '',
        createdBy: "",
        description: '',
        geolocation: '',
        observations: '',
        inventoryId: '',
        imagePaths: []);

    material = box.values
        .firstWhere((material) => material.tag == tag, orElse: () => material);

    return material;
  }

  Future<void> saveMaterialToFirestore(var user, String geolocationStr, String departmentId) async {
     try {
      CollectionReference materials =
          FirebaseFirestore.instance.collection('materials');
      DocumentReference departmentRef = FirebaseFirestore.instance.collection('departments').doc(departmentId);
      Map<String, dynamic> data = {
        "tag": tagController.text.trim(),
        "description": descriptionController.text.trim(),
        "name": nameController.text.trim(),
        "geolocation": geolocationStr,
        "observations": observationsController.text.trim(),
        "inventory": {
          "inventory Id": null, 
          "inventory name": null, 
          "inventory description ": null,
        },
        "reports": {
          "created_at": FieldValue.serverTimestamp(),
          "created_by": user.email ?? "",
          "updated_at": "",
          "updated_by": "",
        },
        "images": {
          "image1": "",
          "image2": "",
          "image3": "",
        },

        "active": true,
      };
      await materials.add(data);
      await departmentRef.collection('materials').add(data);

      print("Inventário salvo no Firestore com sucesso!");
    } catch (e) {
      print("Erro ao salvar Inventário: $e");
    }
  }
  Future<void> saveMaterialTempToFirestore(var user, String geolocationStr, String departmentId) async {
    
  }
  Future<void> saveMaterialToHive(var user, String geolocationStr,
      String codDepartment, BuildContext context) async {
    try {
      MaterialModel retornado = await checkMaterial(tagController.text.trim());
      if (retornado.tag == "") {
        final box = Hive.box<MaterialModel>('materials');
        final material = MaterialModel(
          name: nameController.text.trim(),
          tag: tagController.text.trim(),
          createdBy: user.email,
          description: descriptionController.text.trim(),
          geolocation: geolocationStr,
          observations: observationsController.text.trim(),
          inventoryId: codDepartment,
          imagePaths: images.isNotEmpty ? images : null,
        );
        await box.add(material);
      } else {
        navigateToMaterialDetails(context, retornado);
      }

      clearData();
    } catch (e) {
      print(e.toString());
    }
  }

  // Função para salvar os dados
  Future<void> saveMaterial( BuildContext context, String geolocationStr, String codDepartment) async {
   var user = _authService.currentUser;
    await saveMaterialToFirestore(user, geolocationStr, "abyTlSLCo2r0Od3AiUQ1");
    await saveMaterialToHive(user, geolocationStr, codDepartment, context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("material adicionado com sucesso!")),
    );
  }

  List<MaterialModel> getMaterials() {
    final box = Hive.box<MaterialModel>('materials');
    return box.values.toList();
  }

  List<MaterialModel> getMaterialsByDepartment(String deptId) {
    final materials = getMaterials();
    final inventoryIds =
        getInventoriesByDept(deptId).map((inv) => inv.id).toList();
    return materials
        .where((mat) => inventoryIds.contains(mat.inventoryId))
        .toList();
  }

  List<MaterialModel> getMaterialsByInventory(String inventoryId) {
    final materials = getMaterials();
    return materials.where((mat) => mat.inventoryId == inventoryId).toList();
  }

  List<InventoryModel> getInventoriesByDept(String deptId) {
    return _inventoryController.getInventoriesByDepartment(deptId);
  }

  List<InventoryModel> getInventories() {
    return _inventoryController.getInventories();
  }

  Future<void> navigateToMaterialDetails(
      BuildContext context, MaterialModel material) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MaterialDetailsPage(material: material),
      ),
    );
  }

  Future<void> fetchAndSaveAllMaterials() async {
  try {
    // Referência à coleção de materiais no Firestore
    CollectionReference materials =
        FirebaseFirestore.instance.collection('materials');

    // Busca todos os documentos da coleção
    QuerySnapshot querySnapshot = await materials.get();

    // Referência ao box do Hive
    final box = Hive.box<MaterialModel>('materials');

    // Itera sobre os documentos e salva no Hive
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      final material = MaterialModel(
       // id: doc.id,
        name: data['name'] ?? '',
        tag: data['tag'] ?? '',
        createdBy: data['reports']?['created_by'] ?? '',
        description: data['description'] ?? '',
        geolocation: data['geolocation'] ?? '',
        observations: data['observations'] ?? '',
        inventoryId: data['inventory']?['inventory Id'] ?? '',
        /*imagePaths: [
          data['images']?['image1'] ?? '',
          data['images']?['image2'] ?? '',
          data['images']?['image3'] ?? '',
        ].where((path) => path.isNotEmpty).toList(),*/
      );

      // Salva no Hive usando o ID como chave
      await box.put(doc.id, material);
    }

    print("Todos os materiais foram buscados do Firestore e salvos no Hive com sucesso!");
  } catch (e) {
    print("Erro ao buscar e salvar materiais: $e");
  }
}
}
