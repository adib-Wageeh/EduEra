import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/features/exams/data/dataSource/exam_remote_Data_source.dart';
import 'package:education_app/core/common/features/course/features/exams/data/repository/exam_repo_impl.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam_question.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ExamRemoteDataSourceMock extends Mock implements
    ExamRemoteDataSource{}

void main() {
  
  late ExamRemoteDataSource examRemoteDataSource;
  late ExamRepositoryImpl examRepositoryImpl;
  final tExam = Exam.empty();
  final tUserExam = UserExam.empty();
  const tCourseId = 'courseId';
  const tException = ServerException(error: 'unknown error', code: '404');

  setUp(() {

    examRemoteDataSource = ExamRemoteDataSourceMock();
    examRepositoryImpl = ExamRepositoryImpl
      (examRemoteDataSource: examRemoteDataSource);
    registerFallbackValue(tExam);
    registerFallbackValue(tUserExam);

  });


  group('getExamQuestions', (){

    test('returning right hand side List<ExamQuestion>', () async{
      when(
          ()=> examRemoteDataSource.getExamQuestions(any()),
      ).thenAnswer((_) async=> []);

      final result = await examRepositoryImpl.getExamQuestions(tExam);

      expect(result, isA<Right<dynamic,List<ExamQuestion>>>());
      verify(
          ()=> examRemoteDataSource.getExamQuestions(tExam),
      ).called(1);
      verifyNoMoreInteractions(examRemoteDataSource);
    });

    test('returning left hand side exception', () async{
      when(
            ()=> examRemoteDataSource.getExamQuestions(any()),
      ).thenThrow(tException);

      final result = await examRepositoryImpl.getExamQuestions(tExam);

      expect(result,Left<ServerFailure,dynamic>
        (ServerFailure.fromException(tException)),);
      verify(
            ()=> examRemoteDataSource.getExamQuestions(tExam),
      ).called(1);
      verifyNoMoreInteractions(examRemoteDataSource);
    });

  });

  group('getExams', (){

    test('returning right hand side List<Exam>', () async{
      when(
            ()=> examRemoteDataSource.getExams(any()),
      ).thenAnswer((_) async=> []);

      final result = await examRepositoryImpl.getExams(tCourseId);

      expect(result, isA<Right<dynamic,List<Exam>>>());
      verify(
            ()=> examRemoteDataSource.getExams(tCourseId),
      ).called(1);
      verifyNoMoreInteractions(examRemoteDataSource);
    });

    test('returning left hand side exception', () async{
      when(
            ()=> examRemoteDataSource.getExams(any()),
      ).thenThrow(tException);

      final result = await examRepositoryImpl.getExams(tCourseId);

      expect(result,Left<ServerFailure,dynamic>
        (ServerFailure.fromException(tException)),);
      verify(
            ()=> examRemoteDataSource.getExams(tCourseId),
      ).called(1);
      verifyNoMoreInteractions(examRemoteDataSource);
    });

  });

  group('getUserCourseExams', (){

    test('returning right hand side List<UserExam>', () async{
      when(
            ()=> examRemoteDataSource.getUserCourseExam(tCourseId),
      ).thenAnswer((_) async=> []);

      final result = await examRepositoryImpl.getUserCourseExams(tCourseId);

      expect(result, isA<Right<dynamic,List<UserExam>>>());
      verify(
            ()=> examRemoteDataSource.getUserCourseExam(tCourseId),
      ).called(1);
      verifyNoMoreInteractions(examRemoteDataSource);
    });

    test('returning left hand side exception', () async{
      when(
            ()=> examRemoteDataSource.getUserCourseExam(tCourseId),
      ).thenThrow(tException);

      final result = await examRepositoryImpl.getUserCourseExams(tCourseId);

      expect(result,Left<ServerFailure,dynamic>
        (ServerFailure.fromException(tException)),);
      verify(
            ()=> examRemoteDataSource.getUserCourseExam(tCourseId),
      ).called(1);
      verifyNoMoreInteractions(examRemoteDataSource);
    });

  });
  
  group('getUserExams', (){

    test('returning right hand side List<UserExam>', () async{
      when(
            ()=> examRemoteDataSource.getUserExams(),
      ).thenAnswer((_) async=> []);

      final result = await examRepositoryImpl.getUserExams();

      expect(result, isA<Right<dynamic,List<UserExam>>>());
      verify(
            ()=> examRemoteDataSource.getUserExams(),
      ).called(1);
      verifyNoMoreInteractions(examRemoteDataSource);
    });

    test('returning left hand side exception', () async{
      when(
            ()=> examRemoteDataSource.getUserExams(),
      ).thenThrow(tException);

      final result = await examRepositoryImpl.getUserExams();

      expect(result,Left<ServerFailure,dynamic>
        (ServerFailure.fromException(tException)),);
      verify(
            ()=> examRemoteDataSource.getUserExams(),
      ).called(1);
      verifyNoMoreInteractions(examRemoteDataSource);
    });

  });

  group('submitExam', (){

    test('returning right hand side void', () async{
      when(
            ()=> examRemoteDataSource.submitExam(any()),
      ).thenAnswer((_) async=> []);

      final result = await examRepositoryImpl.submitExam(tUserExam);

      expect(result, isA<Right<dynamic,void>>());
      verify(
            ()=> examRemoteDataSource.submitExam(tUserExam),
      ).called(1);
      verifyNoMoreInteractions(examRemoteDataSource);
    });

    test('returning left hand side exception', () async{
      when(
            ()=> examRemoteDataSource.submitExam(any()),
      ).thenThrow(tException);

      final result = await examRepositoryImpl.submitExam(tUserExam);

      expect(result,Left<ServerFailure,dynamic>
        (ServerFailure.fromException(tException)),);
      verify(
            ()=> examRemoteDataSource.submitExam(tUserExam),
      ).called(1);
      verifyNoMoreInteractions(examRemoteDataSource);
    });

  });

  group('updateExam', (){

    test('returning right hand side List<UserExam>', () async{
      when(
            ()=> examRemoteDataSource.updateExam(any()),
      ).thenAnswer((_) async=> []);

      final result = await examRepositoryImpl.updateExam(tExam);

      expect(result, isA<Right<dynamic,void>>());
      verify(
            ()=> examRemoteDataSource.updateExam(tExam),
      ).called(1);
      verifyNoMoreInteractions(examRemoteDataSource);
    });

    test('returning left hand side exception', () async{
      when(
            ()=> examRemoteDataSource.updateExam(any()),
      ).thenThrow(tException);

      final result = await examRepositoryImpl.updateExam(tExam);

      expect(result,Left<ServerFailure,dynamic>
        (ServerFailure.fromException(tException)),);
      verify(
            ()=> examRemoteDataSource.updateExam(tExam),
      ).called(1);
      verifyNoMoreInteractions(examRemoteDataSource);
    });

  });

  group('getUserExams', (){

    test('returning right hand side List<UserExam>', () async{
      when(
            ()=> examRemoteDataSource.getUserExams(),
      ).thenAnswer((_) async=> []);

      final result = await examRepositoryImpl.getUserExams();

      expect(result, isA<Right<dynamic,List<UserExam>>>());
      verify(
            ()=> examRemoteDataSource.getUserExams(),
      ).called(1);
      verifyNoMoreInteractions(examRemoteDataSource);
    });

    test('returning left hand side exception', () async{
      when(
            ()=> examRemoteDataSource.getUserExams(),
      ).thenThrow(tException);

      final result = await examRepositoryImpl.getUserExams();

      expect(result,Left<ServerFailure,dynamic>
        (ServerFailure.fromException(tException)),);
      verify(
            ()=> examRemoteDataSource.getUserExams(),
      ).called(1);
      verifyNoMoreInteractions(examRemoteDataSource);
    });

  });



}

