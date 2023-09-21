import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/entities/materials.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/repository/materials_repo.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/usecases/add_resource_use_case.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ResourcesRepositoryMock extends Mock implements ResourcesRepository{}

void main() {

  late ResourcesRepository resourcesRepository;
  late AddResourceUseCase addResourceUseCase;
  final tRes = Resources.empty();
  const tFailure = ServerFailure(
    error: 'unknown failure',code: '404',
  );

  setUp(() {
    resourcesRepository = ResourcesRepositoryMock();
    addResourceUseCase = AddResourceUseCase(
      repository: resourcesRepository,);
    registerFallbackValue(tRes);
  });

  test('resource should be added successfully and returns right hand side',
          () async{

        // arrange
        when(()=> resourcesRepository.addResource(any()))
            .thenAnswer((_) async=> const Right(null));

        // act
        final result = await addResourceUseCase.call(tRes);

        // assert
        expect(result, const Right<dynamic,void>(null));

      });

  test('resource should not be added successfully and returns left hand side',
          () async{

        // arrange
        when(()=> resourcesRepository.addResource(any()))
            .thenAnswer((_) async=> const Left(tFailure));

        // act
        final result = await addResourceUseCase.call(tRes);

        // assert
        expect(result, const Left<ServerFailure,dynamic>(tFailure));

      });

}
