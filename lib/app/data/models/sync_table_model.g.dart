// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_table_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SyncTableModelAdapter extends TypeAdapter<SyncTableModel> {
  @override
  final int typeId = 3;

  @override
  SyncTableModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncTableModel(
      originTable: fields[1] as String,
      objectId: fields[2] as String,
    )
      ..id = fields[0] as String
      ..created = fields[3] as DateTime;
  }

  @override
  void write(BinaryWriter writer, SyncTableModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.originTable)
      ..writeByte(2)
      ..write(obj.objectId)
      ..writeByte(3)
      ..write(obj.created);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncTableModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
