import 'package:hive/hive.dart';

part 'streak_model.g.dart';

@HiveType(typeId: 3)
class StreakModel extends HiveObject {
  @HiveField(0)
  int currentStreak;

  @HiveField(1)
  int longestStreak;

  @HiveField(2)
  DateTime? lastPracticeDate;

  StreakModel({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastPracticeDate,
  });
}
