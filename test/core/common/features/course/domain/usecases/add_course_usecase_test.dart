import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/common/features/course/domain/repositories/course_repo.dart';
import 'package:education_app/core/common/features/course/domain/usecases/add_course_usecase.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class CourseRepositoryMock extends Mock implements CourseRepository{}

void main() {

  late AddCourseUseCase addCourseUseCase;
  late CourseRepository courseRepository;
  final course = Course.empty();
  const serverFailureTest = ServerFailure(error: '',code: '');

  setUp(() {
    courseRepository = CourseRepositoryMock();
    addCourseUseCase = AddCourseUseCase(courseRepository: courseRepository);
    registerFallbackValue(course);
  });

  test('successfully adding a course and returning right hand side', () async{

    // arrange
    when(
        ()=> courseRepository.addCourse(any()),
    ).thenAnswer((_) async => const Right(null));

    // act
    final result = await addCourseUseCase.call(course);

    // assert
    expect(result, equals(const Right<dynamic,void>(null)));


  });

  test('unsuccessfully adding a course and returning left hand side', () async{

    // arrange
    when(
          ()=> courseRepository.addCourse(any()),
    ).thenAnswer((_) async => const Left(ServerFailure(
      code: '',error: '',
    ),),);

    // act
    final result = await addCourseUseCase.call(course);

    // assert
    expect(result, equals( const Left<Failure,dynamic>(
        serverFailureTest
    ,),),);


  });

}
