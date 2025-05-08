import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventoryplatform/app/controllers/image_controller.dart';
import 'package:inventoryplatform/app/controllers/inventory_controller.dart';
import 'package:inventoryplatform/app/data/models/inventory_model.dart';
import 'package:inventoryplatform/app/data/models/material_model.dart';
import 'package:inventoryplatform/app/services/auth_service.dart';

import 'package:inventoryplatform/app/ui/device/pages/material_details_page.dart';
import 'package:inventoryplatform/app/ui/device/theme/custom_bd_dialogs.dart';

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
  final ImageController _imageController = Get.find<ImageController>();

  final ImagePicker picker = ImagePicker();

  final List<String> images = [];
  RxList<File?> imagesList = RxList<File?>([]);
  Rx<File?> image = Rx<File?>(null);
  late String hiveMaterialId;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAndSaveAllMaterials(); // Chama a função ao inicializar o controlador
  }

  @override
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
    images.clear();
    imagesList.clear();
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
        final XFile? pickedFile = await picker.pickImage(source: source);
        if (pickedFile != null) {
          final File image = File(pickedFile.path);
          images.add(image.path);
          imagesList.add(image);
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

  Future<void> saveMaterialToFirestore(
      var user, String geolocationStr, String inventoryId) async {
    try {
      List<String> imagens =
          await _imageController.convertImagesToBase64(imagesList);

      // Garantir que a lista tenha pelo menos 3 imagens
      while (imagens.length < 3) {
        imagens.add(""); // Adiciona strings vazias para evitar erros
      }

      CollectionReference materials =
          FirebaseFirestore.instance.collection('materials');
      DocumentReference inventoryReference =
          FirebaseFirestore.instance.collection('inventories').doc(inventoryId);

      Map<String, dynamic> data = {
        "tag": tagController.text.trim(),
        "description": descriptionController.text.trim(),
        "name": nameController.text.trim(),
        "geolocation": geolocationStr,
        "observations": observationsController.text.trim(),
        "inventory Id": inventoryId,
        "reports": {
          "created_at": FieldValue.serverTimestamp(),
          "created_by": user.email ?? "",
          "updated_at": "",
          "updated_by": "",
        },
        "images": {
          "image1": imagens[0],
          "image2": imagens[1],
          "image3": imagens[2],
        },
        "active": true,
      };

      await materials.doc(hiveMaterialId).set(data);
      await inventoryReference
          .collection('materials')
          .doc(hiveMaterialId)
          .set(data);

      debugPrint("Material salvo no Firestore com sucesso!");
    } catch (e) {
      debugPrint("Erro ao salvar material: $e");
    }
  }

  Future<void> saveMaterialToHive(var user, String geolocationStr,
      String inventorieId, BuildContext context) async {
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
          inventoryId: inventorieId,
          imagePaths: images.isNotEmpty ? images : null,
        );
        await box.add(material);
        hiveMaterialId = material.id;
        debugPrint(material.imagePaths?.toString());
      } else {
        navigateToMaterialDetails(context, retornado);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Função para salvar os dados
  Future<void> saveMaterial(
      BuildContext context, String geolocationStr, String inventoryId) async {
    var user = _authService.currentUser;
    bool firestoreSuccess = false;
    bool hiveSuccess = false;
    CustomDialogs.showLoadingDialog(
        "Carregando informações para o banco local...");

    try {
      await Future.delayed(
          const Duration(seconds: 2)); // Garante 2 segundos de exibição
      await saveMaterialToHive(user, geolocationStr, inventoryId, context);
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
    CustomDialogs.showLoadingDialog(
        "Carregando informações para o banco online...");
    try {
      await Future.delayed(
          const Duration(seconds: 2)); // Garante 2 segundos de exibição
      await saveMaterialToFirestore(user, geolocationStr, inventoryId);
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
    printMaterialImagePaths();
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
        List<String> allimages = [];
        allimages.add(data['images']['image1']);
        allimages.add(data['images']['image2']);
        allimages.add(data['images']['image3']);

        List<String> imagens =
            (await _imageController.convertBase64ToImages(allimages));
        final material = MaterialModel(
          id: doc.id,
          name: data['name'] ?? '',
          tag: data['tag'] ?? '',
          createdBy: data['reports']?['created_by'] ?? '',
          description: data['description'] ?? '',
          geolocation: data['geolocation'] ?? '',
          observations: data['observations'] ?? '',
          inventoryId: data['inventory']?['inventory Id'] ?? '',
          imagePaths: [
            imagens[0],
            imagens[1],
            imagens[2],
          ],
        );

        // Salva no Hive usando o ID como chave
        await box.put(doc.id, material);
      }

      debugPrint(
          "Todos os materiais foram buscados do Firestore e salvos no Hive com sucesso!");
    } catch (e) {
      debugPrint("Erro ao buscar e salvar materiais: $e");
    }
  }

  void printMaterialImagePaths() {
    final box = Hive.box<MaterialModel>('materials');
    final materials = box.values.toList();

    for (var material in materials) {
      debugPrint('Material: ${material.name}');
      debugPrint('Image Paths: ${material.imagePaths}');
    }
  }
}
