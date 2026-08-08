import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/settings_repository.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository repository;

  SettingsBloc({required this.repository}) : super(const SettingsState()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateSettingsEvent>(_onUpdateSettings);
  }

  Future<void> _onLoadSettings(LoadSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(isLoading: true));
    
    final settings = await repository.getSettings();

    emit(state.copyWith(
      isLoading: false,
      settings: settings,
    ));
  }

  Future<void> _onUpdateSettings(UpdateSettingsEvent event, Emitter<SettingsState> emit) async {
    await repository.saveSettings(event.settings);
    
    // Reload state
    add(LoadSettingsEvent());
  }
}
