import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'material_model.g.dart';


@HiveType(typeId: 2)
class MaterialModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String? tag;

  @HiveField(2)
  String title;

  @HiveField(3)
  String observations;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  Map<String,String>? geolocation;

  @HiveField(6)
  String description;

  @HiveField(7)
  String? inventoryId;

  @HiveField(8)
  List<String>? imagePaths;

  @HiveField(9)
  String createdBy;

  @HiveField(10)
  DateTime updatedAt;

  @HiveField(11)
  String updatedBy;

  @HiveField(12)
  bool active;

  MaterialModel({
    String? id, // Torna o ID opcional
    this.tag,
    required this.title,
    required this.observations,
    this.geolocation,
    required this.description,
    required this.inventoryId,
    required this.createdBy,
    this.imagePaths,
  }) : id = id ?? Uuid().v4(), // Gera um ID automaticamente se não for fornecido
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        updatedBy = createdBy,
        active = true;

  MaterialModel.existing({
    required this.id,
    required this.title,
    required this.description,
    required this.observations,
    required this.inventoryId,
    required this.active,
    required this.imagePaths,
    this.geolocation,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    this.tag
  });
}