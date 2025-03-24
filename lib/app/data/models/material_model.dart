import 'package:hive/hive.dart';
part 'material_model.g.dart';

@HiveType(typeId: 2)
class MaterialModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String? barcode;

  @HiveField(2)
  String name;

  @HiveField(3)
  String observations;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  String geolocation;

  @HiveField(6)
  String description;

  @HiveField(7)
  String inventoryId;

  @HiveField(8)
  String? imagePath;

  MaterialModel({
    required this.id,
    this.barcode,
    required this.name,
    required this.observations,
    required this.date,
    required this.geolocation,
    required this.description,
    required this.inventoryId,
    this.imagePath,

  }) ;
}