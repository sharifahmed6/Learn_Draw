import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/repositories/settings_repository.dart';
import '../models/app_settings_model.dart';

class HiveSettingsRepository implements SettingsRepository {
  final Box<AppSettingsModel> _settingsBox = Hive.box<AppSettingsModel>(LocalStorageService.appSettingsBox);

  @override
  Future<AppSettingsModel> getSettings() async {
    return _settingsBox.get('default') ?? AppSettingsModel();
  }

  @override
  Future<void> saveSettings(AppSettingsModel settings) async {
    await _settingsBox.put('default', settings);
  }
}
