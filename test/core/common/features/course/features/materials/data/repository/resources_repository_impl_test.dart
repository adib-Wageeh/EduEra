import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/features/materials/data/dataSource/resources_reomte_data_source.dart';
import 'package:education_app/core/common/features/course/features/materials/data/repository/resources_repository_impl.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/entities/materials.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ResourcesRemoteDataSourceMock extends Mock implements
    ResourcesRemoteDataSource{}

void main() {

  late ResourcesRemoteDataSource remoteDataSource;
  late ResourcesRepositoryImpl repositoryImpl;
  final tRes = Resources.empty();
  const tException = ServerException(
    error: 'unknown error',
    code: '404',
  );

  setUp(() {

    remoteDataSource = ResourcesRemoteDataSourceMock();
    repositoryImpl = ResourcesRepositoryImpl
      (remoteDataSource: remoteDataSource);
    registerFallbackValue(tRes);
  });

  group('add resources', () {

    test('adding resource successfully and returning right hand side', () async{

      when(()=> remoteDataSource.addResource(any()))
          .thenAnswer((_) async=> Future.value);

      final result = await repositoryImpl.addResource(tRes);

      expect(result, const Right<dynamic,void>(null));
    });

    test('adding resource unsuccessfully and returning left hand side', ()async{

      when(()=> remoteDataSource.addResource(any()))
          .thenThrow(tException);

      final result = await repositoryImpl.addResource(tRes);

      expect(result,Left<ServerFailure,dynamic>
        (ServerFailure.fromException(tException)),);
    });

  });



}
