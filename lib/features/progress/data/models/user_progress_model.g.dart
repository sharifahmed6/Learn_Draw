// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProgressModelAdapter extends TypeAdapter<UserProgressModel> {
  @override
  final int typeId = 0;

  @override
  UserProgressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProgressModel(
      itemId: fields[0] as String,
      category: fields[1] as String,
      completed: fields[2] as bool,
      bestScore: fields[3] as int,
      attemptCount: fields[4] as int,
      lastPracticeDate: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProgressModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.completed)
      ..writeByte(3)
      ..write(obj.bestScore)
      ..writeByte(4)
      ..write(obj.attemptCount)
      ..writeByte(5)
      ..write(obj.lastPracticeDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProgressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
