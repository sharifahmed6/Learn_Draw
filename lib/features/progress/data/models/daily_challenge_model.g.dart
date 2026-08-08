// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_challenge_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyChallengeModelAdapter extends TypeAdapter<DailyChallengeModel> {
  @override
  final int typeId = 2;

  @override
  DailyChallengeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyChallengeModel(
      date: fields[0] as String,
      assignedItems: (fields[1] as List).cast<String>(),
      completedItems: (fields[2] as List).cast<String>(),
      isCompleted: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DailyChallengeModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.assignedItems)
      ..writeByte(2)
      ..write(obj.completedItems)
      ..writeByte(3)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyChallengeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
