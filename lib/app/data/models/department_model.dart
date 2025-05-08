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
  DateTime created_at;

  @HiveField(6)
  DateTime updated_at;

  @HiveField(7)
  String created_by;

  @HiveField(8)
  String updated_by;

  DepartmentModel({
    required this.title,
    required this.description,
    required this.created_by,
    this.imagePath,
  })  : id = const Uuid().v4(),
        active = true,
        created_at = DateTime.now(),
        updated_at = DateTime.now(),
        updated_by = created_by;

  DepartmentModel.existing({
    required this.id,
    required this.title,
    required this.description,
    required this.active,
    required this.created_at,
    required this.updated_at,
    required this.created_by,
    required this.updated_by,
    this.imagePath,
  });
}
