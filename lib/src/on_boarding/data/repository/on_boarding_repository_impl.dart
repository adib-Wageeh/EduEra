import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/on_boarding/data/datasorces/onboarding_local_datasource.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repo.dart';

class OnBoardingRepositoryImpl implements OnBoardingRepository{

  const OnBoardingRepositoryImpl({required this.dataSource});
  final OnBoardingLocalDataSource dataSource;

  @override
  ResultFuture<void> cacheFirstTime() async{

    try {
      await dataSource.cacheFirstTime();
      return const Right(null);
    }on CacheException catch (e){
      return Left(CacheFailure(error: e.error, code: e.code));
    }
  }

  @override
  ResultFuture<bool> checkIfUserFirstTime() async{

    try {
      final result = await dataSource.checkIfUserFirstTime();
      return Right(result);
    }on CacheException catch (e){
      return Left(CacheFailure(error: e.error, code: e.code));
    }
  }



}