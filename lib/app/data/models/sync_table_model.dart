import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'sync_table_model.g.dart';

@HiveType(typeId: 3)
class SyncTableModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String originTable;

  @HiveField(2)
  String objectId;

  @HiveField(3)
  DateTime created;

  SyncTableModel({
    required this.originTable,
    required this.objectId,
  })  : id = const Uuid().v4(),
        created = DateTime.now();
}
