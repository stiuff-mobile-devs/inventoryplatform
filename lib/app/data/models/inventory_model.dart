import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'inventory_model.g.dart';

@HiveType(typeId: 1)
class InventoryModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String revisionNumber;

  @HiveField(4)
  bool active;

  @HiveField(5)
  String departmentId;

  @HiveField(6)
  DateTime created_at;

  @HiveField(7)
  DateTime updated_at;

  @HiveField(8)
  String created_by;

  @HiveField(9)
  String updated_by;

  InventoryModel({
    required this.title,
    required this.description,
    required this.revisionNumber,
    required this.departmentId,
    required this.created_by,
  }) : id = Uuid().v4(),
        created_at = DateTime.now(),
        updated_at = DateTime.now(),
        updated_by = created_by,
        active = true;

  InventoryModel.existing({
    required this.id,
    required this.title,
    required this.description,
    required this.revisionNumber,
    required this.departmentId,
    required this.active,
    required this.created_at,
    required this.updated_at,
    required this.created_by,
    required this.updated_by
  });
}