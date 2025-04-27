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
    )
      ..id = fields[0] as String
      ..active = fields[4] as bool
      ..created = fields[6] as DateTime
      ..modified = fields[7] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, InventoryModel obj) {
    writer
      ..writeByte(8)
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
      ..write(obj.created)
      ..writeByte(7)
      ..write(obj.modified);
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
