import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/data/datasourses/course_remote_data_source.dart';
import 'package:education_app/core/common/features/course/data/models/course_model.dart';
import 'package:education_app/core/common/features/course/data/repository/course_repository_impl.dart';
import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class CourseRemoteDataSourceMock extends Mock
    implements CourseRemoteDataSource{}

void main() {

  late CourseRemoteDataSource courseRemoteDataSource;
  late CourseRepositoryImplementation courseRepositoryImplementation;
  final course = Course.empty();
  final courseModel = CourseModel.empty();

  const tServerException = ServerException(code: '404',
  error: 'unreachable server',);
  const tServerFailure = ServerFailure(code: '404',
    error: 'unreachable server',);

  setUp((){

    courseRemoteDataSource = CourseRemoteDataSourceMock();
    courseRepositoryImplementation = CourseRepositoryImplementation
      (courseRemoteDataSource: courseRemoteDataSource);
    registerFallbackValue(course);
  });

  group('add course', () {

    test('successfully adding a course and returning right hand side', () async{

      // arrange
      when(()=> courseRemoteDataSource.addCourse(any()))
          .thenAnswer((_) async=> Future.value());

      // act
      final result = await courseRepositoryImplementation.addCourse(course);

      // assert
      expect(result, const Right<dynamic,void>(null));
      verify(()=> courseRemoteDataSource.addCourse(course)).called(1);
      verifyNoMoreInteractions(courseRemoteDataSource);
    });

    test('unsuccessfully adding a course and returning left hand side',
            () async{

      // arrange
      when(()=> courseRemoteDataSource.addCourse(any()))
          .thenThrow(tServerException);

      // act
      final result = await courseRepositoryImplementation.addCourse(course);

      // assert
      expect(result,
          const Left<ServerFailure,dynamic>(tServerFailure), );
    });
  });

  group('get course', () {

    test('successfully getting courses and returning right hand side', () async{

      // arrange
      when(()=> courseRemoteDataSource.getCourses())
          .thenAnswer((_) async=> <CourseModel>[courseModel]);

      // act
      final result = await courseRepositoryImplementation.getCourses();

      // assert
      expect(result, isA<Right<dynamic,List<Course>>>() );
      verify(()=> courseRemoteDataSource.getCourses()).called(1);
      verifyNoMoreInteractions(courseRemoteDataSource);
    });

    test('unsuccessfully adding a course and returning left hand side',
            () async{

          // arrange
          when(()=> courseRemoteDataSource.getCourses())
              .thenThrow(tServerException);

          // act
          final result = await courseRepositoryImplementation.getCourses();

          // assert
          expect(result,
            const Left<ServerFailure,dynamic>(tServerFailure), );
        });
  });

}
