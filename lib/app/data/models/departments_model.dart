import 'package:hive/hive.dart';

part 'departments_model.g.dart';

@HiveType(typeId: 0)
class DepartmentsModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  String? imagePath;

  DepartmentsModel({
    required this.title,
    required this.description,
    this.imagePath,
  });
}