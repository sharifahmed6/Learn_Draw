import 'package:get_it/get_it.dart';
import 'features/home/bloc/home_bloc.dart';
import 'features/progress/domain/repositories/progress_repository.dart';
import 'features/progress/data/repositories/hive_progress_repository.dart';
import 'features/progress/presentation/bloc/progress_bloc.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/data/repositories/hive_settings_repository.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Progress & Settings
  // Repositories
  sl.registerLazySingleton<ProgressRepository>(() => HiveProgressRepository());
  sl.registerLazySingleton<SettingsRepository>(() => HiveSettingsRepository());

  // Blocs
  sl.registerFactory(() => ProgressBloc(repository: sl()));
  sl.registerFactory(() => SettingsBloc(repository: sl()));

  //! Features - Home
  // Bloc
  sl.registerFactory(() => HomeBloc());

  //! Features - Drawing
  // Bloc

  // Use cases

  // Repository

  // Data sources

  //! Core

  //! External
}
