// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materials_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MaterialsModelAdapter extends TypeAdapter<MaterialsModel> {
  @override
  final int typeId = 2;

  @override
  MaterialsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MaterialsModel(
      barcode: fields[1] as String,
      name: fields[2] as String,
      observations: fields[3] as String,
      date: fields[4] as DateTime,
      geolocation: fields[5] as String,
      description: fields[6] as String,
      inventoryId: fields[7] as String,
    )..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, MaterialsModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.barcode)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.observations)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.geolocation)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.inventoryId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaterialsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
