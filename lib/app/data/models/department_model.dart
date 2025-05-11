import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'department_model.g.dart';

@HiveType(typeId: 0)
class DepartmentModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String? imagePath;

  @HiveField(4)
  bool active;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime updatedAt;

  @HiveField(7)
  String createdBy;

  @HiveField(8)
  String updatedBy;

  DepartmentModel({
    required this.title,
    required this.description,
    required this.createdBy,
    required this.imagePath,
  }) : id = Uuid().v4(),
        active = true,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        updatedBy = createdBy;

  DepartmentModel.existing({
    required this.id,
    required this.title,
    required this.description,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.imagePath,
  });
}