import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/repositories/progress_repository.dart';
import '../models/user_progress_model.dart';
import '../models/practice_history_model.dart';
import '../models/daily_challenge_model.dart';
import '../models/streak_model.dart';

class HiveProgressRepository implements ProgressRepository {
  final Box<UserProgressModel> _progressBox = Hive.box<UserProgressModel>(LocalStorageService.userProgressBox);
  final Box<PracticeHistoryModel> _historyBox = Hive.box<PracticeHistoryModel>(LocalStorageService.practiceHistoryBox);
  final Box<DailyChallengeModel> _challengeBox = Hive.box<DailyChallengeModel>(LocalStorageService.dailyChallengeBox);
  final Box<StreakModel> _streakBox = Hive.box<StreakModel>(LocalStorageService.streakBox);

  // --- User Progress ---
  @override
  Future<void> saveProgress(UserProgressModel progress) async {
    final key = '${progress.category}_${progress.itemId}';
    await _progressBox.put(key, progress);
  }

  @override
  Future<UserProgressModel?> getProgress(String itemId, String category) async {
    final key = '${category}_$itemId';
    return _progressBox.get(key);
  }

  @override
  Future<List<UserProgressModel>> getAllProgress() async {
    return _progressBox.values.where((progress) {
      return progress.category != 'continue_learning_data' && progress.category != 'curriculum';
    }).toList();
  }

  // --- Practice History ---
  @override
  Future<void> savePracticeHistory(PracticeHistoryModel history) async {
    await _historyBox.add(history);
  }

  @override
  Future<List<PracticeHistoryModel>> getPracticeHistory() async {
    return _historyBox.values.toList();
  }

  @override
  Future<void> deleteOldPracticeHistory(DateTime cutoff) async {
    final keysToDelete = [];
    for (var i = 0; i < _historyBox.length; i++) {
      final history = _historyBox.getAt(i);
      if (history != null && history.completedAt.isBefore(cutoff)) {
        keysToDelete.add(_historyBox.keyAt(i));
      }
    }
    await _historyBox.deleteAll(keysToDelete);
  }

  // --- Daily Challenge ---
  @override
  Future<void> saveDailyChallenge(DailyChallengeModel challenge) async {
    await _challengeBox.put(challenge.date, challenge);
  }

  @override
  Future<DailyChallengeModel?> getDailyChallenge(String date) async {
    return _challengeBox.get(date);
  }

  // --- Streak ---
  @override
  Future<StreakModel> getStreak() async {
    return _streakBox.get('default') ?? StreakModel();
  }

  @override
  Future<void> updateStreak(DateTime practiceDate) async {
    final streak = await getStreak();
    
    if (streak.lastPracticeDate == null) {
      streak.currentStreak = 1;
      streak.longestStreak = 1;
      streak.lastPracticeDate = practiceDate;
    } else {
      final lastDate = streak.lastPracticeDate!;
      // Check if practice is on a new day
      if (practiceDate.year == lastDate.year && practiceDate.month == lastDate.month && practiceDate.day == lastDate.day) {
        // Same day, do nothing to streak count
      } else {
        final difference = DateTime(practiceDate.year, practiceDate.month, practiceDate.day)
            .difference(DateTime(lastDate.year, lastDate.month, lastDate.day))
            .inDays;
        
        if (difference == 1) {
          // Consecutive day
          streak.currentStreak += 1;
          if (streak.currentStreak > streak.longestStreak) {
            streak.longestStreak = streak.currentStreak;
          }
        } else if (difference > 1) {
          // Missed a day
          streak.currentStreak = 1;
        }
        streak.lastPracticeDate = practiceDate;
      }
    }
    await _streakBox.put('default', streak);
  }

  // --- Continue Learning ---
  // Using SharedPreferences or a specific key in UserProgressBox for this. Let's use UserProgressBox with a special key.
  @override
  Future<void> saveLastPractice(String dataJson) async {
    final progress = UserProgressModel(
      itemId: dataJson,
      category: 'continue_learning_data',
      lastPracticeDate: DateTime.now(),
    );
    await _progressBox.put('last_practice', progress);
  }

  @override
  Future<Map<String, dynamic>?> getLastPractice() async {
    final progress = _progressBox.get('last_practice');
    if (progress != null && progress.category == 'continue_learning_data') {
      try {
        return jsonDecode(progress.itemId) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // --- Curriculum ---
  @override
  Future<int> getCurriculumDay() async {
    final progress = _progressBox.get('curriculum_day');
    if (progress != null && progress.category == 'curriculum') {
      return int.tryParse(progress.itemId) ?? 1;
    }
    return 1;
  }

  @override
  Future<void> incrementCurriculumDay() async {
    int currentDay = await getCurriculumDay();
    currentDay += 1;
    final progress = UserProgressModel(
      itemId: currentDay.toString(),
      category: 'curriculum',
      lastPracticeDate: DateTime.now(),
    );
    await _progressBox.put('curriculum_day', progress);
  }
}
