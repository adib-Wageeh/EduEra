import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_time_usecase.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_first_time.dart';
import 'package:education_app/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheFirstTimeUseCase extends Mock implements CacheFirstTimeUseCase{}
class MockCheckIfUserFirstTime extends Mock implements CheckIfUserFirstTimeUseCase{}

void main() {

  late CacheFirstTimeUseCase cacheFirstTimeUseCase;
  late CheckIfUserFirstTimeUseCase checkIfUserFirstTimeUseCase;
  late OnBoardingCubit onBoardingCubit;

  setUp(() {
    cacheFirstTimeUseCase = MockCacheFirstTimeUseCase();
    checkIfUserFirstTimeUseCase = MockCheckIfUserFirstTime();
    onBoardingCubit = OnBoardingCubit(cacheFirst: cacheFirstTimeUseCase
        , checkIfFirstTime: checkIfUserFirstTimeUseCase,);
  });

  const tFailure = CacheFailure(
    error: 'an error occurred', code: 400,);
  group('caching first time', () {

    blocTest<OnBoardingCubit, OnBoardingState>(
    'should emit caching first time and user cached if successful'
    ,
      build: () {
        when(() => cacheFirstTimeUseCase())
            .thenAnswer((_) async => const Right(null));
        return onBoardingCubit;
      }
      ,
      act: (cubit) =>cubit.cacheFirstTime(),
      expect: () => <OnBoardingState>[
        const CachingFirstTime(),
        const UserCached(),
      ],
    );

    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emit caching first time and OnBoardingError if an error occurred'
      ,
      build: () {
        when(() => cacheFirstTimeUseCase())
            .thenAnswer((_) async => const Left(tFailure,),);
        return onBoardingCubit;
      }
      ,
      act: (cubit) =>cubit.cacheFirstTime(),
      expect: () => <OnBoardingState>[
        const CachingFirstTime(),
        OnBoardingError(message: tFailure.error),
      ],
    );

  });

  group('check if user opens the app for the first time', () {

    blocTest<OnBoardingCubit, OnBoardingState>(
      'should open onBoarding screen when the usecase returns true'
      ,
      build: () {
        when(() => checkIfUserFirstTimeUseCase())
            .thenAnswer((_) async => const Right(true));
        return onBoardingCubit;
      }
      ,
      act: (cubit) =>cubit.checkIfUserIsFirst(),
      expect: () => <OnBoardingState>[
        const CheckingIfUserFirstTime(),
        const OnBoardingStatus(isFirstTime: true),
      ],
    );

    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emit OnBoardingError if an error occurred'
      ,
      build: () {
        when(() => checkIfUserFirstTimeUseCase())
            .thenAnswer((_) async => const Left(tFailure,),);
        return onBoardingCubit;
      }
      ,
      act: (cubit) =>cubit.checkIfUserIsFirst(),
      expect: () => <OnBoardingState>[
        const CheckingIfUserFirstTime(),
        const OnBoardingStatus(isFirstTime: true),
      ],
    );

  });

}