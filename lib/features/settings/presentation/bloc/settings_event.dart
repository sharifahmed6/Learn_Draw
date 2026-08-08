import 'package:equatable/equatable.dart';
import '../../data/models/app_settings_model.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {}

class UpdateSettingsEvent extends SettingsEvent {
  final AppSettingsModel settings;

  const UpdateSettingsEvent({required this.settings});

  @override
  List<Object> get props => [settings];
}
