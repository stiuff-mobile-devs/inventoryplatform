import 'package:hive/hive.dart';

part 'tag_model.g.dart';

@HiveType(typeId: 3)
class TagModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String type;

  @HiveField(2)
  DateTime date;

  TagModel({
    required this.id,
    required this.type,
    required this.date,
  }) ;
}