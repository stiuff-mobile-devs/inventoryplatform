// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventories_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InventoriesModelAdapter extends TypeAdapter<InventoriesModel> {
  @override
  final int typeId = 1;

  @override
  InventoriesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InventoriesModel(
      title: fields[1] as String,
      description: fields[2] as String,
      revisionNumber: fields[3] as String,
      departmentId: fields[4] as String,
    )..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, InventoriesModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.revisionNumber)
      ..writeByte(4)
      ..write(obj.departmentId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoriesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
