import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:inventoryplatform/app/controllers/department_controller.dart';
import 'package:inventoryplatform/app/controllers/inventory_controller.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';
import 'package:inventoryplatform/app/data/models/sync_table_model.dart';

class SyncController extends GetxController {
  final DepartmentController departmentController = DepartmentController();
  final InventoryController inventoryController = InventoryController();

  @override
  void onInit() {
    super.onInit();
    _syncRemoteToLocal();
    _syncLocalToRemote();
  }

  void _syncLocalToRemote() async {
    final box = Hive.box<SyncTableModel>('unsynchronized');

    if (box.length > 0) {
      for (var item in box.values) {
        bool success = false;
        switch (item.originTable) {
          case "departments":
            success = await departmentController.syncDepartment(item.objectId);
            break;

          case "inventories":
            success = await inventoryController.syncInventory(item.objectId);
            break;
        }

        if (success) {
          await box.delete(item.id);
        }
      }
    }

  }

  void _syncRemoteToLocal() async {
    final box = Hive.box<SyncTableModel>('unsynchronized');
    FirebaseFirestore.instance
        .collection('Departamento')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        var data = doc.data();
        final department = DepartmentModel(
          title: data['title'],
          description: data['description'],
        );
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
}
