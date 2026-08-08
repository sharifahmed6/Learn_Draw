import 'package:hive/hive.dart';

part 'app_settings_model.g.dart';

@HiveType(typeId: 4)
class AppSettingsModel extends HiveObject {
  @HiveField(0)
  bool soundEnabled;

  @HiveField(1)
  bool musicEnabled;

  @HiveField(2)
  bool hapticEnabled;

  @HiveField(3)
  String selectedLanguage;

  @HiveField(4)
  String? selectedChildName;

  AppSettingsModel({
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.hapticEnabled = true,
    this.selectedLanguage = 'en',
    this.selectedChildName,
  });
}
