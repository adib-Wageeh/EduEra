import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/on_boarding/data/datasorces/onboarding_local_datasource.dart';
import 'package:education_app/src/on_boarding/data/repository/on_boarding_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnBoardingLocalDataSource extends Mock implements
    OnBoardingLocalDataSource{}

void main() {

  late OnBoardingLocalDataSource onBoardingLocalDataSource;
  late OnBoardingRepositoryImpl onBoardingRepositoryImpl;

  setUp(() {
    onBoardingLocalDataSource = MockOnBoardingLocalDataSource();
    onBoardingRepositoryImpl = OnBoardingRepositoryImpl(
        dataSource: onBoardingLocalDataSource,);
  });

  group('cache first time', () {

    test('should complete successfully when call to local source', () async{

      when(()=>
      onBoardingLocalDataSource.cacheFirstTime(),
      ).thenAnswer((invocation) async=> Future.value);

      final result = await onBoardingRepositoryImpl.cacheFirstTime();

      expect(result, const Right<dynamic,void>(null));
      verify(()=>onBoardingLocalDataSource.cacheFirstTime()).called(1);
      verifyNoMoreInteractions(onBoardingLocalDataSource);
    });

    test('should return a cache failure when call to local '
        'source unsuccessfully', () async{

      when(()=>
          onBoardingLocalDataSource.cacheFirstTime(),
      ).thenThrow(const CacheException(error: 'no storage available', code: 400
      ,),);

      final result = await onBoardingRepositoryImpl.cacheFirstTime();

      expect(result, const Left<CacheFailure,void>(CacheFailure(
          error: 'no storage available',code: 400,),),);
      verify(()=>onBoardingLocalDataSource.cacheFirstTime()).called(1);
      verifyNoMoreInteractions(onBoardingLocalDataSource);
    });

  });

}