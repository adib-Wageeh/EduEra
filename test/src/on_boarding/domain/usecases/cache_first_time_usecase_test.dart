import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repo.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_time_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'on_boarding_repo.mock.dart';



void main() {

  late OnBoardingRepository onBoardingRepository;
  late CacheFirstTimeUseCase cacheFirstTimeUseCase;

  setUp(() {
    onBoardingRepository = MockOnBoardingRepository();
    cacheFirstTimeUseCase = CacheFirstTimeUseCase(
        onBoardingRepository: onBoardingRepository,);
  });


  test('should return the right hand side', () async{

    when(()=> onBoardingRepository.cacheFirstTime(),
    ).thenAnswer((_) async=> const Right(null));

    final result = await cacheFirstTimeUseCase.call();

    expect(result, const Right<Failure,void>(null));
    verify(()=> onBoardingRepository.cacheFirstTime()).called(1);
    verifyNoMoreInteractions(onBoardingRepository);

  });

  const tCacheFailure = CacheFailure(error: 'error message', code: 400);
  test('should return the left hand side (error)', () async{

    when(()=> onBoardingRepository.cacheFirstTime(),
    ).thenAnswer((_) async=> const Left(tCacheFailure));

    final result = await cacheFirstTimeUseCase.call();

    expect(result, const Left<Failure,void>(tCacheFailure));
    verify(()=> onBoardingRepository.cacheFirstTime()).called(1);
    verifyNoMoreInteractions(onBoardingRepository);

  });

}