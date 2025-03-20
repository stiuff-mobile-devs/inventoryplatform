import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'departments_model.g.dart';

@HiveType(typeId: 0)
class DepartmentsModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String? imagePath;

  DepartmentsModel({
    required this.title,
    required this.description,
    this.imagePath,
  }) : id = Uuid().v4(); // Generate a unique ID
}