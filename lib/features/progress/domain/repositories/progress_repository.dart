import '../../data/models/user_progress_model.dart';
import '../../data/models/practice_history_model.dart';
import '../../data/models/daily_challenge_model.dart';
import '../../data/models/streak_model.dart';

abstract class ProgressRepository {
  // User Progress
  Future<void> saveProgress(UserProgressModel progress);
  Future<UserProgressModel?> getProgress(String itemId, String category);
  Future<List<UserProgressModel>> getAllProgress();

  // Practice History
  Future<void> savePracticeHistory(PracticeHistoryModel history);
  Future<List<PracticeHistoryModel>> getPracticeHistory();
  Future<void> deleteOldPracticeHistory(DateTime cutoff);

  // Daily Challenge
  Future<void> saveDailyChallenge(DailyChallengeModel challenge);
  Future<DailyChallengeModel?> getDailyChallenge(String date);

  // Streak
  Future<StreakModel> getStreak();
  Future<void> updateStreak(DateTime practiceDate);
  
  // Continue Learning
  Future<void> saveLastPractice(String dataJson);
  Future<Map<String, dynamic>?> getLastPractice();

  // Curriculum
  Future<int> getCurriculumDay();
  Future<void> incrementCurriculumDay();
}
