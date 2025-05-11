// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MaterialModelAdapter extends TypeAdapter<MaterialModel> {
  @override
  final int typeId = 2;

  @override
  MaterialModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MaterialModel(
      id: fields[0] as String?,
      tag: fields[1] as String?,
      title: fields[2] as String,
      observations: fields[3] as String,
      geolocation: (fields[5] as Map).cast<String, String>(),
      description: fields[6] as String,
      inventoryId: fields[7] as String?,
      createdBy: fields[9] as String,
      imagePaths: (fields[8] as List?)?.cast<String>(),
    )
      ..createdAt = fields[4] as DateTime
      ..updatedAt = fields[10] as DateTime
      ..updatedBy = fields[11] as String
      ..active = fields[12] as bool;
  }

  @override
  void write(BinaryWriter writer, MaterialModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tag)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.observations)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.geolocation)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.inventoryId)
      ..writeByte(8)
      ..write(obj.imagePaths)
      ..writeByte(9)
      ..write(obj.createdBy)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.updatedBy)
      ..writeByte(12)
      ..write(obj.active);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaterialModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
