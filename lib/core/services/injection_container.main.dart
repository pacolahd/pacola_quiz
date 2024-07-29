part of 'injection_container.dart';

// This is the main file for the dependency injection container.
// when the GetIt.instance is called, the app will look for the import in the injection_container.dart file
// and then execute the code in the file thereby importing all the dependencies in the file.

// In other files, we import only the injection_container.dart file and not the injection_container.main.dart file

final sl = GetIt.instance;

Future<void> init() async {
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  sl.registerLazySingleton(() => supabase.client);

  await _initOnBoarding();
  await _initAuth();
}

class AppSecrets {
  static const supabaseUrl = 'https://<supabase-url>.supabase.co';
  static const supabaseAnonKey = '<sup';
}

Future<void> _initAuth() async {
  // Feature --> Auth
  // Business Logic

  sl
    ..registerFactory(
      () => AuthBloc(
        signIn: sl(),
        signUp: sl(),
        forgotPassword: sl(),
        updateUser: sl(),
        signInWithGoogle: sl(),
      ),
    )
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => SignInWithGoogle(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => ForgotPassword(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()))
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(supabaseClient: sl()),
    );
}

Future<void> _initOnBoarding() async {
  // We await for the shared prefs to load before we inject any other dependencies.
  // We want only 1 shared prefs instance to be created and used throughout the app
  final prefs = await SharedPreferences.getInstance();
  // Feature --> OnBoarding
  // Business Logic

  sl
    ..registerFactory(
      () => OnBoardingCubit(
        cacheFirstTimer: sl(),
        checkIfUserIsFirstTimer: sl(),
      ),
    )
    ..registerLazySingleton(() => CacheFirstTimer(sl()))
    ..registerLazySingleton(() => CheckIfUserIsFirstTimer(sl()))
    ..registerLazySingleton<OnBoardingRepo>(() => OnBoardingRepoImpl(sl()))
    ..registerLazySingleton<OnBoardingLocalDataSource>(
        () => OnBoardingLocalDataSrcImpl(sl()))
    ..registerLazySingleton(() => prefs);
}
