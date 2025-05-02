// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InventoryModelAdapter extends TypeAdapter<InventoryModel> {
  @override
  final int typeId = 1;

  @override
  InventoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InventoryModel(
      title: fields[1] as String,
      description: fields[2] as String,
      revisionNumber: fields[3] as String,
      departmentId: fields[5] as String,
      created_by: fields[8] as String,
    )
      ..id = fields[0] as String
      ..active = fields[4] as bool
      ..created_at = fields[6] as DateTime
      ..updated_at = fields[7] as DateTime
      ..updated_by = fields[9] as String;
  }

  @override
  void write(BinaryWriter writer, InventoryModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.revisionNumber)
      ..writeByte(4)
      ..write(obj.active)
      ..writeByte(5)
      ..write(obj.departmentId)
      ..writeByte(6)
      ..write(obj.created_at)
      ..writeByte(7)
      ..write(obj.updated_at)
      ..writeByte(8)
      ..write(obj.created_by)
      ..writeByte(9)
      ..write(obj.updated_by);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
