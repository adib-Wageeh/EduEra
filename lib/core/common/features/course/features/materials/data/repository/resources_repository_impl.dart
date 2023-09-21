import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/features/materials/data/dataSource/resources_reomte_data_source.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/entities/materials.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/repository/materials_repo.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/core/utils/typedefs.dart';

class ResourcesRepositoryImpl implements ResourcesRepository{

  ResourcesRepositoryImpl({required this.remoteDataSource,});

  final ResourcesRemoteDataSource remoteDataSource;

  @override
  ResultFuture<void> addResource(Resources resources) async{
    try{

      await remoteDataSource.addResource(resources);
      return const Right(null);
    }on ServerException catch(e){
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Resources>> getResources(String p) async{
    try{

      final result = await remoteDataSource.getResources(p);
      return Right(result);
    }on ServerException catch(e){
      return Left(ServerFailure.fromException(e));
    }
  }



}
