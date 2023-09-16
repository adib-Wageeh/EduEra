import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/common/features/course/domain/repositories/course_repo.dart';
import 'package:education_app/core/common/features/course/domain/use-cases/get_courses_use_case.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class CourseRepositoryMock extends Mock implements CourseRepository{}


void main() {

  late GetCoursesUseCase getCoursesUseCase;
  late CourseRepository courseRepository;

  final courses = <Course>[
    Course.empty(),
    Course.empty(),
  ];

  const serverFailureTest = ServerFailure(error: '',code: '');

  setUp(() {
    courseRepository = CourseRepositoryMock();
    getCoursesUseCase = GetCoursesUseCase(courseRepository: courseRepository);
    registerFallbackValue(courses);
  });

  test('successfully getting courses and returning right hand side', () async{

    // arrange
    when(
          ()=> courseRepository.getCourses(),
    ).thenAnswer((_) async => Right(courses));

    // act
    final result = await getCoursesUseCase.call();

    // assert
    expect(result, equals(Right<dynamic,List<Course>>(courses)));


  });

  test('unsuccessfully getting courses and returning left hand side', () async{

    // arrange
    when(
          ()=> courseRepository.getCourses(),
    ).thenAnswer((_) async => const Left(ServerFailure(
      code: '',error: '',
    ),),);

    // act
    final result = await getCoursesUseCase.call();

    // assert
    expect(result, equals( const Left<Failure,dynamic>(
      serverFailureTest
      ,),),);


  });

}
