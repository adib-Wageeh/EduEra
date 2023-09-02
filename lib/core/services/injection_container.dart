import 'package:education_app/src/on_boarding/data/datasorces/onboarding_local_datasource.dart';
import 'package:education_app/src/on_boarding/data/repository/on_boarding_repository_impl.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repo.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_time_usecase.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_first_time.dart';
import 'package:education_app/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init()async{

final prefs = await SharedPreferences.getInstance();
sl..registerFactory(() => OnBoardingCubit(cacheFirst: sl()
  ,checkIfFirstTime: sl(),))..
registerLazySingleton(() => CacheFirstTimeUseCase(onBoardingRepository: sl()))
    ..registerLazySingleton(() => CheckIfUserFirstTimeUseCase(
        onBoardingRepository: sl()))..registerLazySingleton
<OnBoardingRepository>(() => OnBoardingRepositoryImpl(dataSource: sl()))
..registerLazySingleton<OnBoardingLocalDataSource>(
        () => OnBoardingLocalDataSourceImpl(
            sharedPreferences: prefs,),);
}
