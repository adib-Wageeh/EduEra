import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/features/exams/data/dataSource/exam_remote_Data_source.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam_question.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/repos/exam_repo.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/core/utils/typedefs.dart';

class ExamRepositoryImpl implements ExamRepository{

  ExamRepositoryImpl({required this.examRemoteDataSource});

  final ExamRemoteDataSource examRemoteDataSource;

  @override
  ResultFuture<List<ExamQuestion>> getExamQuestions(Exam exam) async{
    try{
      final result = await examRemoteDataSource.getExamQuestions(exam);
      return Right(result);
    }on ServerException catch(e){
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Exam>> getExams(String courseId) async{
    try{
      final result = await examRemoteDataSource.getExams(courseId);
      return Right(result);
    }on ServerException catch(e){
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<UserExam>> getUserCourseExams(String courseId) async{
    try{
      final result = await examRemoteDataSource.getUserCourseExam(courseId);
      return Right(result);
    }on ServerException catch(e){
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<UserExam>> getUserExams() async{
    try{
      final result = await examRemoteDataSource.getUserExams();
      return Right(result);
    }on ServerException catch(e){
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> submitExam(UserExam exam) async{
    try{
      await examRemoteDataSource.submitExam(exam);
      return const Right(null);
    }on ServerException catch(e){
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> updateExam(Exam exam) async{
    try{
      await examRemoteDataSource.updateExam(exam);
      return const Right(null);
    }on ServerException catch(e){
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> uploadExam(Exam exam) async{
    try{
      await examRemoteDataSource.uploadExam(exam);
      return const Right(null);
    }on ServerException catch(e){
      return Left(ServerFailure.fromException(e));
    }
  }



}
