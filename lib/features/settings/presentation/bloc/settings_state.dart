import 'package:equatable/equatable.dart';
import '../../data/models/app_settings_model.dart';

class SettingsState extends Equatable {
  final bool isLoading;
  final AppSettingsModel? settings;

  const SettingsState({
    this.isLoading = false,
    this.settings,
  });

  SettingsState copyWith({
    bool? isLoading,
    AppSettingsModel? settings,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [isLoading, settings];
}
