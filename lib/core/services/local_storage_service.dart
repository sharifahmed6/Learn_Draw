import 'package:hive_flutter/hive_flutter.dart';
import '../../features/progress/data/models/user_progress_model.dart';
import '../../features/progress/data/models/practice_history_model.dart';
import '../../features/progress/data/models/daily_challenge_model.dart';
import '../../features/progress/data/models/streak_model.dart';
import '../../features/settings/data/models/app_settings_model.dart';

class LocalStorageService {
  static const String userProgressBox = 'user_progress';
  static const String practiceHistoryBox = 'practice_history';
  static const String dailyChallengeBox = 'daily_challenge';
  static const String streakBox = 'streak';
  static const String appSettingsBox = 'app_settings';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(UserProgressModelAdapter());
    Hive.registerAdapter(PracticeHistoryModelAdapter());
    Hive.registerAdapter(DailyChallengeModelAdapter());
    Hive.registerAdapter(StreakModelAdapter());
    Hive.registerAdapter(AppSettingsModelAdapter());

    // Open Boxes
    await Future.wait([
      Hive.openBox<UserProgressModel>(userProgressBox),
      Hive.openBox<PracticeHistoryModel>(practiceHistoryBox),
      Hive.openBox<DailyChallengeModel>(dailyChallengeBox),
      Hive.openBox<StreakModel>(streakBox),
      Hive.openBox<AppSettingsModel>(appSettingsBox),
    ]);
    
    // Initialize default settings if empty
    final settingsBox = Hive.box<AppSettingsModel>(appSettingsBox);
    if (settingsBox.isEmpty) {
      await settingsBox.put('default', AppSettingsModel());
    }

    // Initialize streak if empty
    final streakBoxInstance = Hive.box<StreakModel>(streakBox);
    if (streakBoxInstance.isEmpty) {
      await streakBoxInstance.put('default', StreakModel());
    }
  }
}
