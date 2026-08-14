import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/services/deep_link_handler.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/data/datasources/profile_remote_datasource.dart';
import 'features/profile/domain/usecases/create_profile.dart';
import 'features/profile/domain/usecases/get_profile.dart';
import 'features/profile/domain/usecases/update_profile.dart';
import 'features/profile/domain/usecases/upload_profile_image.dart';
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
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  //! Features - Auth
  // Datasource
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => SignupUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUsecase(sl()));

  // Bloc
  sl.registerFactory(() => AuthBloc(
        login: sl(),
        signup: sl(),
        logout: sl(),
        getCurrentUser: sl(),
      ));

  sl.registerFactory(() => ForgotPasswordBloc(authRepository: sl()));

  //! Features - Profile
  // Datasource
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => CreateProfile(sl()));
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerLazySingleton(() => UploadProfileImage(sl()));

  // Bloc
  sl.registerFactory(() => ProfileBloc(
        supabaseClient: sl(),
        getProfile: sl(),
        updateProfile: sl(),
        uploadProfileImage: sl(),
      ));

  sl.registerLazySingleton<DeepLinkService>(
        () => DeepLinkService(),
  );
}
