import 'package:hive/hive.dart';

part 'daily_challenge_model.g.dart';

@HiveType(typeId: 2)
class DailyChallengeModel extends HiveObject {
  @HiveField(0)
  final String date; // YYYY-MM-DD

  @HiveField(1)
  final List<String> assignedItems;

  @HiveField(2)
  List<String> completedItems;

  @HiveField(3)
  bool isCompleted;

  DailyChallengeModel({
    required this.date,
    required this.assignedItems,
    this.completedItems = const [],
    this.isCompleted = false,
  });
}
