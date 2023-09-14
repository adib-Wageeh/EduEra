import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/data/datasourses/course_remote_data_source.dart';
import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/common/features/course/domain/repositories/course_repo.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/core/utils/typedefs.dart';

class CourseRepositoryImplementation implements CourseRepository{

  const CourseRepositoryImplementation({required this.courseRemoteDataSource});

  final CourseRemoteDataSource courseRemoteDataSource;

  @override
  ResultFuture<void> addCourse(Course course) async{
    try{
     await courseRemoteDataSource.addCourse(course);
     return const Right(null);
    }on ServerException catch (e){
      return Left(ServerFailure(error: e.error,code: e.code));
    }
  }

  @override
  ResultFuture<List<Course>> getCourses() async{
    try{
      final courses = await courseRemoteDataSource.getCourses();
      return Right(courses);
    }on ServerException catch (e){
      return Left(ServerFailure(error: e.error,code: e.code));
    }
  }



}