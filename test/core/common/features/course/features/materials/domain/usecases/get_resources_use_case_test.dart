
import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/entities/materials.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/repository/materials_repo.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/usecases/get_resources_use_case.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ResourcesRepositoryMock extends Mock implements ResourcesRepository{}

void main() {

  late ResourcesRepository resourcesRepository;
  late GetResourceUseCase getResourceUseCase;
  final tRes = Resources.empty();
  const tFailure = ServerFailure(
    error: 'unknown failure',code: '404',
  );

  setUp(() {
    resourcesRepository = ResourcesRepositoryMock();
    getResourceUseCase = GetResourceUseCase(
      repository: resourcesRepository,);
    registerFallbackValue(tRes);
  });

  test('resource should be returned successfully and returns right hand side',
          () async{

        // arrange
        when(()=> resourcesRepository.getResources(any()))
            .thenAnswer((_) async=>  const Right([]));

        // act
        final result = await getResourceUseCase.call('course_id');

        // assert
        expect(result, const Right<dynamic,List<Resources>>([]));

      });

  test('resource should not be returned successfully and returns left hand side'
      ,() async{

        // arrange
        when(()=> resourcesRepository.getResources(any()))
            .thenAnswer((_) async=> const Left(tFailure));

        // act
        final result = await getResourceUseCase.call('course_id');

        // assert
        expect(result, const Left<ServerFailure,dynamic>(tFailure));

      });

}