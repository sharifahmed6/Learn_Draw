// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PracticeHistoryModelAdapter extends TypeAdapter<PracticeHistoryModel> {
  @override
  final int typeId = 1;

  @override
  PracticeHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PracticeHistoryModel(
      itemId: fields[0] as String,
      category: fields[1] as String,
      practiceType: fields[2] as String,
      score: fields[3] as int,
      durationSeconds: fields[4] as int,
      completedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PracticeHistoryModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.practiceType)
      ..writeByte(3)
      ..write(obj.score)
      ..writeByte(4)
      ..write(obj.durationSeconds)
      ..writeByte(5)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PracticeHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
