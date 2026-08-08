import 'package:hive/hive.dart';

part 'practice_history_model.g.dart';

@HiveType(typeId: 1)
class PracticeHistoryModel extends HiveObject {
  @HiveField(0)
  final String itemId;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final String practiceType;

  @HiveField(3)
  final int score;

  @HiveField(4)
  final int durationSeconds;

  @HiveField(5)
  final DateTime completedAt;

  PracticeHistoryModel({
    required this.itemId,
    required this.category,
    required this.practiceType,
    required this.score,
    required this.durationSeconds,
    required this.completedAt,
  });
}
