// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DepartmentModelAdapter extends TypeAdapter<DepartmentModel> {
  @override
  final int typeId = 0;

  @override
  DepartmentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DepartmentModel(
      title: fields[1] as String,
      description: fields[2] as String,
      imagePath: fields[3] as String?,
      createdBy: fields[5] as String,
      updateBy: fields[6] as String?,
      updateAt: fields[7] as String?,
    )
      ..id = fields[0] as String
      ..createdAt = fields[4] as DateTime
      ..active = fields[8] as bool;
  }

  @override
  void write(BinaryWriter writer, DepartmentModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.imagePath)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.createdBy)
      ..writeByte(6)
      ..write(obj.updateBy)
      ..writeByte(7)
      ..write(obj.updateAt)
      ..writeByte(8)
      ..write(obj.active);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DepartmentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
