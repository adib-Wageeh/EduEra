part of 'injection_container.dart';


final sl = GetIt.instance;

Future<void> init()async{

 await _onBoardingInit();

 await _authInit();


}

Future<void> _onBoardingInit()async{

  final prefs = await SharedPreferences.getInstance();

  sl..registerFactory(() => OnBoardingCubit(cacheFirst: sl()
    ,checkIfFirstTime: sl(),),)
    ..registerLazySingleton(() => CacheFirstTimeUseCase(
        onBoardingRepository: sl(),),)
    ..registerLazySingleton(() => CheckIfUserFirstTimeUseCase(
      onBoardingRepository: sl(),),)..registerLazySingleton
  <OnBoardingRepository>(() => OnBoardingRepositoryImpl(dataSource: sl()))
    ..registerLazySingleton<OnBoardingLocalDataSource>(
          () => OnBoardingLocalDataSourceImpl(
        sharedPreferences: sl(),),)
  ..registerLazySingleton(() => prefs);
}

Future<void> _authInit()async{

  final storagePrefs = FirebaseStorage.instance;
  final firestorePrefs =  FirebaseFirestore.instance;
  final authPrefs = FirebaseAuth.instance;

  sl..registerFactory(() => AuthBloc(forgetPasswordUseCase: sl(),
  signInUseCase: sl(),signUpUseCase: sl(),
  updateDataUseCase: sl(),),)..registerLazySingleton(() =>
  ForgetPasswordUseCase(authenticationRepository: sl()),
  )..registerLazySingleton(() => SignInUseCase(authenticationRepository: sl()))
  ..registerLazySingleton(() => SignUpUseCase(authenticationRepository: sl()))
  ..registerLazySingleton(() => UpdateDataUseCase(
      authenticationRepository: sl(),),)
  ..registerLazySingleton<AuthenticationRepository>(() =>
  AuthenticationRepositoryImpl(authRemoteDataSource: sl()),)..
  registerLazySingleton<AuthRemoteDataSource>(() =>
  AuthRemoteDataSourceImpl(firebaseAuth: sl(),
  firebaseFirestore: sl(),
  firebaseStorage: sl(),),)
  ..registerLazySingleton(() => storagePrefs)
  ..registerLazySingleton(() => firestorePrefs)
  ..registerLazySingleton(() => authPrefs);
}
