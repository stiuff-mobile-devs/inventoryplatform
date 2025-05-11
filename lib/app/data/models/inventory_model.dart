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
  DateTime createdAt;

  @HiveField(7)
  DateTime updatedAt;

  @HiveField(8)
  String createdBy;

  @HiveField(9)
  String updatedBy;

  InventoryModel({
    required this.title,
    required this.description,
    required this.revisionNumber,
    required this.departmentId,
    required this.createdBy,
  }) : id = Uuid().v4(),
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        updatedBy = createdBy,
        active = true;

  InventoryModel.existing({
    required this.id,
    required this.title,
    required this.description,
    required this.revisionNumber,
    required this.departmentId,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy
  });
}