// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'departments_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DepartmentsModelAdapter extends TypeAdapter<DepartmentsModel> {
  @override
  final int typeId = 0;

  @override
  DepartmentsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DepartmentsModel(
      title: fields[1] as String,
      description: fields[2] as String,
      imagePath: fields[3] as String?,
    )..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, DepartmentsModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DepartmentsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
