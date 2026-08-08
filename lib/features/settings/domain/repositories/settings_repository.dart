import '../../data/models/app_settings_model.dart';

abstract class SettingsRepository {
  Future<AppSettingsModel> getSettings();
  Future<void> saveSettings(AppSettingsModel settings);
}
