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
  String name;

  @HiveField(3)
  String observations;

  @HiveField(4)
  DateTime createdAt = DateTime.now();

  @HiveField(5)
  String geolocation;

  @HiveField(6)
  String description;

  @HiveField(7)
  String? inventoryId;

  @HiveField(8)
  List<String>? imagePaths;

  @HiveField(9)
  String createdBy;

  @HiveField(10)
  DateTime? updatedAt;

  @HiveField(11)
  String? updatedBy;

  @HiveField(12)
  bool active = true;

  MaterialModel({
    String? id, // Torna o ID opcional
    this.tag,
    required this.name,
    required this.observations,
    required this.geolocation,
    required this.description,
    required this.inventoryId,
    required this.createdBy,
    this.imagePaths,
    this.updatedAt,
    this.updatedBy,

  }) : id = id ?? Uuid().v4(); // Gera um ID automaticamente se não for fornecido
}