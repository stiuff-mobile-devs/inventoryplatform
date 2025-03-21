import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'inventories_model.g.dart';

@HiveType(typeId: 1)
class InventoriesModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String revisionNumber;

  @HiveField(4)
  String departmentId;

  InventoriesModel({
    required this.title,
    required this.description,
    required this.revisionNumber,
    required this.departmentId,
  }) : id = Uuid().v4(); // Generate a unique ID
}