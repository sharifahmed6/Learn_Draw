import 'package:hive/hive.dart';

part 'user_progress_model.g.dart';

@HiveType(typeId: 0)
class UserProgressModel extends HiveObject {
  @HiveField(0)
  final String itemId;

  @HiveField(1)
  final String category;

  @HiveField(2)
  bool completed;

  @HiveField(3)
  int bestScore;

  @HiveField(4)
  int attemptCount;

  @HiveField(5)
  DateTime? lastPracticeDate;

  UserProgressModel({
    required this.itemId,
    required this.category,
    this.completed = false,
    this.bestScore = 0,
    this.attemptCount = 0,
    this.lastPracticeDate,
  });
}
