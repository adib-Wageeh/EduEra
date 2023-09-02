import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repo.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_first_time.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'on_boarding_repo.mock.dart';

void main() {

  late OnBoardingRepository onBoardingRepository;
  late CheckIfUserFirstTimeUseCase checkIfUserFirstTime;

  setUp(() {
    onBoardingRepository = MockOnBoardingRepository();
    checkIfUserFirstTime = CheckIfUserFirstTimeUseCase(
      onBoardingRepository: onBoardingRepository,);
  });

  test('should return the right hand side (bool)', () async{

      when(()=> onBoardingRepository.checkIfUserFirstTime()).thenAnswer(
              (_) async=> const Right(true),);

      final result = await checkIfUserFirstTime.call();

      expect(result, const Right<Failure,bool>(true));
      verify(()=> onBoardingRepository.checkIfUserFirstTime()).called(1);
      verifyNoMoreInteractions(onBoardingRepository);
  });

  const tCacheFailure = CacheFailure(error: 'error message', code: 400);
  test('should return the left hand side (error)', () async{

    when(()=> onBoardingRepository.checkIfUserFirstTime()).thenAnswer(
          (_) async=> const Left(tCacheFailure),);

    final result = await checkIfUserFirstTime.call();

    expect(result, const Left<Failure,dynamic>(tCacheFailure));
    verify(()=> onBoardingRepository.checkIfUserFirstTime()).called(1);
    verifyNoMoreInteractions(onBoardingRepository);
  });

}
