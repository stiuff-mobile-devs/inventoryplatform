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
  DateTime createdAt = DateTime.now();

  @HiveField(5)
  String? createdBy;

  @HiveField(6)
  String? updateBy;

  @HiveField(7)
  String? updateAt;

  @HiveField(8)
  bool active = true;

  DepartmentModel({
    required this.title,
    required this.description,
    this.imagePath,
    this.createdBy,
    this.updateBy,
    this.updateAt,
  }) : id = Uuid().v4(); // Generate a unique ID
}