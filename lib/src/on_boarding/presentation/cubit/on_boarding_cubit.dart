import 'package:bloc/bloc.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_time_usecase.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_first_time.dart';
import 'package:equatable/equatable.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit({required CacheFirstTimeUseCase cacheFirst
  ,required CheckIfUserFirstTimeUseCase  checkIfFirstTime,})
      :
  cacheFirstTimeUseCase = cacheFirst,
  checkIfUserFirstTimeUseCase = checkIfFirstTime
  ,super(const OnBoardingInitial());

  final CacheFirstTimeUseCase cacheFirstTimeUseCase;
  final CheckIfUserFirstTimeUseCase checkIfUserFirstTimeUseCase;

  Future<void> cacheFirstTime()async{

    emit(const CachingFirstTime());
   final response = await cacheFirstTimeUseCase();

   response.fold((l) => emit(OnBoardingError(message: l.error))
       , (_) => emit(const UserCached()),);

  }

  Future<void> checkIfUserIsFirst()async{

    emit(const CheckingIfUserFirstTime());
    final response = await checkIfUserFirstTimeUseCase();

    response.fold((l) => emit(const OnBoardingStatus(isFirstTime: true))
      , (res) => emit(OnBoardingStatus(isFirstTime: res),),);

  }

}
