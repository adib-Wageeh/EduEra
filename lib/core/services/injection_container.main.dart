part of 'injection_container.dart';


final sl = GetIt.instance;

Future<void> init()async{

 await _onBoardingInit();

 await _authInit();

 await _courseInit();

 await _initVideo();

 await _examInit();
}

Future<void> _courseInit()async{

  sl..registerFactory(() => CourseCubit(addCourseUseCase: sl()
    ,getCoursesUseCase: sl(),),)
    ..registerLazySingleton(() => AddCourseUseCase(courseRepository: sl()),)
    ..registerLazySingleton(() => GetCoursesUseCase(courseRepository: sl()),)
    ..registerLazySingleton<CourseRepository>(()=>
        CourseRepositoryImplementation(courseRemoteDataSource: sl()),)
    ..registerLazySingleton<CourseRemoteDataSource>(
            () => CourseRemoteDataSourceImpl(auth: sl(),firestore: sl()
              ,storage: sl(),),);

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

Future<void> _initVideo()async{

  sl..registerFactory(() => VideoCubit(
    addVideo: sl(),getVideos: sl(),),)
      ..registerLazySingleton(() => AddVideoUseCase(
        videoRepository: sl(),),)
      ..registerLazySingleton(() => GetCoursesUseCase(courseRepository: sl()))
      ..registerLazySingleton<VideoRepository>(() =>
          VideoRepositoryImpl(videoRemoteDataSource: sl(),),)
      ..registerLazySingleton<VideoRemoteDataSource>(
          () => VideoRemoteDataSourceImpl(firestore: sl(),firebaseStorage:sl(),
          firebaseAuth: sl(),),);
}

Future<void> _examInit()async{

  sl..registerFactory(() => ExamCubit(
    getExamQuestions: sl(),
    getExams: sl(),
    getUserCourseExams: sl(),
    getUserExams: sl(),
    submitExam: sl(),
    updateExam: sl(),
    uploadExam: sl(),),)
      ..registerLazySingleton(() => GetExamsQuestionsUseCase
        (examRepository: sl()),)
      ..registerLazySingleton(() => GetExamsUseCase(examRepository: sl()))
      ..registerLazySingleton(() => SubmitExamsUseCase(examRepository: sl()))
      ..registerLazySingleton(() => UpdateExamsUseCase(examRepository: sl()))
      ..registerLazySingleton(() => UploadExamsUseCase(examRepository: sl()))
      ..registerLazySingleton(() => GetUserCourseExamUseCase
        (examRepository: sl()),)
      ..registerLazySingleton(() => GetUserExamsUseCase(examRepository: sl()))
      ..registerLazySingleton<ExamRepository>(() =>
          ExamRepositoryImpl(examRemoteDataSource: sl()),)
      ..registerLazySingleton<ExamRemoteDataSource>
        (() => ExamRemoteDataSourceImpl(firestore: sl(),firebaseAuth: sl()));

}
