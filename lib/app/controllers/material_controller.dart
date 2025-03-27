import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventoryplatform/app/controllers/inventory_controller.dart';
import 'package:inventoryplatform/app/data/models/inventory_model.dart';
import 'package:inventoryplatform/app/data/models/material_model.dart';
import 'package:inventoryplatform/app/ui/device/forms/material_form.dart';
import 'package:inventoryplatform/app/ui/device/pages/material_details_page.dart';

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
    images.clear();
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

  String convertToEPC(String barcode, BuildContext context) {
    String prefix = "UFF"; // Prefixo fixo

    // Converte cada caractere do código de barras para hexadecimal
    String hexBarcode =
        barcode.codeUnits.map((c) => c.toRadixString(16)).join();

    // Concatena o prefixo com o código convertido
    String epc = prefix + hexBarcode;

    // Se o EPC for maior que 24 caracteres, corta e marca o último caractere como "X"
    if (epc.length > 24) {
      epc = epc.substring(0, 23) + "X"; // Último caractere vira "X"
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "⚠️ Aviso: Código de barras muito longo. Último caractere foi marcado com 'X'.")),
      );
    } else {
      // Preenche com zeros se for menor
      epc = epc.padRight(24, '0');
    }

    return epc.toUpperCase();
  }

  Future<dynamic> checkMaterial(String barcode, String id) async {
    var box = await Hive.openBox<MaterialModel>('materials');

    // Cria um material vazio
    MaterialModel material = MaterialModel(
        id: '',
        name: '',
        barcode: '',
        date: DateTime.now(),
        description: '',
        geolocation: '',
        observations: '',
        inventoryId: '',
        imagePaths: []);

    //Busca pelo RFID
    if (barcode.isEmpty) {
      material = box.values
          .firstWhere((material) => material.id == id, orElse: () => material);
    }
    //Busca pelo código de barras
    else if (barcode.isNotEmpty && id.isEmpty) {
      material = box.values.firstWhere(
        (material) => material.barcode == barcode,
        orElse: () => material,
      );
    }
    //Busca pelo RFID e código de barras
    else {
      material = box.values.firstWhere(
        (material) => material.id == id && material.barcode == barcode,
        orElse: () => material,
      );
    }
    return material;
  }

  // Função para salvar os dados
  Future<void> saveMaterial(BuildContext context) async {
    try {
      String newId = convertToEPC(barcodeController.text.trim(), context);
      MaterialModel retornado =
          await checkMaterial(barcodeController.text.trim(), newId);
      if (retornado.id == "") {
        final box = Hive.box<MaterialModel>('materials');
        final material = MaterialModel(
          id: newId,
          name: nameController.text.trim(),
          barcode: barcodeController.text.trim(),
          date: DateTime.parse(dateController.text.trim()),
          description: descriptionController.text.trim(),
          geolocation: geolocationStr,
          observations: observationsController.text.trim(),
          inventoryId: (context.widget as MaterialForm).cod,
          imagePaths: images.isNotEmpty ? images : null,
        );
        await box.add(material);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("material adicionado com sucesso!")),
        );
      } else {
        navigateToMaterialDetails(context, retornado);
      }
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

      // Voltar para a tela anterior
      clearData();
      //Navigator.pop(context);
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

  void navigateToMaterialDetails(BuildContext context, MaterialModel material) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MaterialDetailsPage(material: material),
      ),
    );
  }
}
