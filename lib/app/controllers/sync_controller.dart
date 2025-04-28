import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:inventoryplatform/app/controllers/department_controller.dart';
import 'package:inventoryplatform/app/controllers/inventory_controller.dart';
import 'package:inventoryplatform/app/data/models/sync_table_model.dart';

class SyncController extends GetxController {
  final DepartmentController departmentController = DepartmentController();
  final InventoryController inventoryController = InventoryController();

  @override
  void onInit() {
    super.onInit();
    syncRemoteToLocal();
    _syncLocalToRemote();
  }

  void _syncLocalToRemote() async {
    final box = Hive.box<SyncTableModel>('unsynchronized');

    if (box.length > 0) {
      for (var item in box.values) {
        bool success = false;
        switch (item.originTable) {
          case "departments":
            success = await syncDepartment(item.objectId);
            break;

          case "inventories":
            success = await syncInventory(item.objectId);
            break;
        }

        if (success) {
          await box.delete(item.id);
        }
      }
    }
  }

  void syncRemoteToLocal() async {
    try {
      await _syncRemoteDepartments();
      await _syncRemoteInventories();
    } catch (e) {
      print("erro ao buscar dados do firebase");
    }
  }

  Future<void> _syncRemoteDepartments() async {
    FirebaseFirestore.instance
        .collection('departments')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        if (doc.exists) {
          final dept = departmentController.getDepartmentById(doc.id);
          if (dept != null && (dept.modified)!.isAfter(doc.data()['modified'])) {
            continue;
          } else {
            departmentController.saveExistingDepartmentToLocal(doc.id,doc.data());
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
          if (inv != null && (inv.modified)!.isAfter(doc.data()['modified'])) {
            continue;
          } else {
            inventoryController.saveExistingInventoryToLocal(doc.id,doc.data());
          }
        }
      }
    });
  }

  Future<void> saveToSyncTable(String origin, String id) async {
    final box = Hive.box<SyncTableModel>('unsynchronized');
    try {
      final toSync = SyncTableModel(
          originTable: origin,
          objectId: id
      );

      await box.put(toSync.id, toSync);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> syncDepartment(String deptId) async {
    final department = departmentController.getDepartmentById(deptId);
    if (department != null) {
      await departmentController.saveDepartmentToRemote(department);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> syncInventory(String invId) async {
    final inventory = inventoryController.getInventoryById(invId);
    if (inventory != null) {
      await inventoryController.saveInventoryToRemote(inventory);
      return true;
    } else {
      return false;
    }
  }
}
