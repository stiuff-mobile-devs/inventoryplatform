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
  DateTime created;

  @HiveField(6)
  DateTime? modified;

  DepartmentModel({
    required this.title,
    required this.description,
    this.imagePath,
  }) : id = Uuid().v4(),
        active = true,
        created = DateTime.now(),
        modified = DateTime.now();
}