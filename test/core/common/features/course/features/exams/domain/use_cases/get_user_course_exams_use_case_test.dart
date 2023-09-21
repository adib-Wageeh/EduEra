import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/repos/exam_repo.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/get_user_course_exams_use_case.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'exam_repo_mock.dart';

void main() {

  late ExamRepository examRepository;
  late GetUserCourseExamUseCase getUserCourseExamUseCase;
  const tCourseId = 'courseId';
  const tFailure = ServerFailure(
    error: 'unknown error',
    code: 404,
  );


  setUp(() {
    examRepository = ExamRepositoryMock();
    getUserCourseExamUseCase = GetUserCourseExamUseCase
      (examRepository: examRepository,);
  });

  test('should return right hand side List<UserExam>', () async{

    when(()=> examRepository.getUserCourseExams(any()),
    ).thenAnswer((_) async=> const Right([]));

    final result = await getUserCourseExamUseCase(tCourseId);

    expect(result, const Right<dynamic,List<UserExam>>([]));
    verify(() => examRepository.getUserCourseExams(any())).called(1);
    verifyNoMoreInteractions(examRepository);
  });

  test('should return left hand side failure', () async{

    when(()=> examRepository.getUserCourseExams(any()),
    ).thenAnswer((_) async=> const Left(tFailure));

    final result = await getUserCourseExamUseCase(tCourseId);

    expect(result, const Left<Failure,void>(tFailure));
    verify(() => examRepository.getUserCourseExams(any())).called(1);
    verifyNoMoreInteractions(examRepository);
  });

}
