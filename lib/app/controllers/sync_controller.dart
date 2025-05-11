import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:inventoryplatform/app/controllers/connection_controller.dart';
import 'package:inventoryplatform/app/controllers/department_controller.dart';
import 'package:inventoryplatform/app/controllers/image_controller.dart';
import 'package:inventoryplatform/app/controllers/inventory_controller.dart';
import 'package:inventoryplatform/app/controllers/material_controller.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';
import 'package:inventoryplatform/app/data/models/inventory_model.dart';
import 'package:inventoryplatform/app/data/models/material_model.dart';
import 'package:inventoryplatform/app/services/connection_service.dart';

class SyncController extends GetxController {
  final departmentController = Get.find<DepartmentController>();
  final inventoryController = Get.find<InventoryController>();
  final materialController = Get.find<MaterialController>();
  final ImageController _imageController = ImageController();

  final ConnectionService connectionService = ConnectionService();

  @override
  void onInit() {
    super.onInit();
    sync();
  }

  void sync() {
    _syncRemoteToLocal();
    _syncLocalToRemote();
  }

  // *********** FIREBASE PARA HIVE **************************
  void _syncRemoteToLocal() async {
    if (!(await connectionService.checkInternetConnection())) {
      return;
    }

    try {
      await _syncRemoteDepartments();
      await _syncRemoteInventories();
      await _syncRemoteMaterials();
    } catch (e) {
      print("erro ao buscar dados do firebase: $e");
    }
  }

  Future<void> _syncRemoteDepartments() async {
    FirebaseFirestore.instance
        .collection('departments')
        .snapshots()
        .listen((snapshot) async {
      for (var doc in snapshot.docs) {
        if (doc.exists) {
          final dept = departmentController.getDepartmentById(doc.id);
          final lastModifiedOnRemote = (doc.data()['reports']['updated_at']).toDate();
          if (dept != null && (dept.updatedAt).isAfter(lastModifiedOnRemote)) {
            continue;
          } else {
            final imagem = await _imageController.convertBase64ToImages([doc.data()["imageURL"]]);
            departmentController.saveExistingDepartmentToLocal(doc.id,doc.data(),imagem);
          }
        }
      }
    });
  }

  Future<void> _syncRemoteInventories() async {
    FirebaseFirestore.instance
        .collection('inventories')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        if (doc.exists) {
          final inv = inventoryController.getInventoryById(doc.id);
          final lastModifiedOnRemote = (doc.data()['reports']['updated_at']).toDate();
          if (inv != null && (inv.updatedAt).isAfter(lastModifiedOnRemote)) {
            continue;
          } else {
            inventoryController.saveExistingInventoryToLocal(doc.id,doc.data());
          }
        }
      }
    });
  }

  Future<void> _syncRemoteMaterials() async {
    FirebaseFirestore.instance
        .collection('materials')
        .snapshots()
        .listen((snapshot) async {
      for (var doc in snapshot.docs) {
        if (doc.exists) {
          final mat = materialController.getMaterialById(doc.id);
          final lastModifiedOnRemote = (doc.data()['reports']['updated_at']).toDate();
          if (mat != null && (mat.updatedAt).isAfter(lastModifiedOnRemote)) {
            continue;
          } else {
            List<String> imagens = [];
            imagens.add(doc.data()['images']['image1']);
            imagens.add(doc.data()['images']['image2']);
            imagens.add(doc.data()['images']['image3']);

            final imagensConv = await _imageController.convertBase64ToImages(imagens);
            materialController.saveExistingMaterialToLocal(doc.id,doc.data(),imagensConv);
          }
        }
      }
    });
  }

  // ***************** HIVE PARA FIREBASE ***********************

  void _syncLocalToRemote() async {
    if (!(await connectionService.checkInternetConnection())) {
      return;
    }

    print('AAAAAAAAAAAAAAAAAAAAAA');
    await _syncPendingDepartments();
    await _syncPendingInventories();
    await _syncPendingMaterials();
  }

  Future<void> _syncPendingDepartments() async {
    final box = Hive.box<DepartmentModel>('departments-pending');
    if (box.length > 0) {
      for (var item in box.values) {
        try {
          await departmentController.saveDepartmentToRemote(item);
          await box.delete(item.id);
          await departmentController.saveDepartmentToLocal(item);
        } catch (e) {
          throw Exception("Não foi possível sincronizar departamentos: $e");
        }
      }
    }
  }

  Future<void> _syncPendingInventories() async {
    final box = Hive.box<InventoryModel>('inventories-pending');
    if (box.length > 0) {
      for (var item in box.values) {
        try {
          await inventoryController.saveInventoryToRemote(item);
          await box.delete(item.id);
          await inventoryController.saveInventoryToLocal(item);
        } catch (e) {
          throw Exception("Não foi possível sincronizar inventários: $e");
        }
      }
    }
  }

  Future<void> _syncPendingMaterials() async {
    final box = Hive.box<MaterialModel>('materials-pending');
    if (box.length > 0) {
      for (var item in box.values) {
        try {
          await materialController.syncMaterialToFirestore(item);
        } catch (e) {
          throw Exception("Não foi possível sincronizar materiais: $e");
        }
      }
    }
  }

}
