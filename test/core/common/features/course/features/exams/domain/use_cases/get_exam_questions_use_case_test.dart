import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam_question.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/repos/exam_repo.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/get_exam_questions_use_case.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'exam_repo_mock.dart';

void main() {

  late ExamRepository examRepository;
  late GetExamsQuestionsUseCase getExamsQuestionsUseCase;
  final tExamQuestion = ExamQuestion.empty();
  final tExam = Exam.empty();
  const tFailure = ServerFailure(
    error: 'unknown error',
    code: 404,
  );


  setUp(() {

    examRepository = ExamRepositoryMock();
    getExamsQuestionsUseCase = GetExamsQuestionsUseCase
      (examRepository: examRepository,);
    registerFallbackValue(tExamQuestion);
    registerFallbackValue(tExam);

  });

  test('should return right hand side List<ExamQuestion>', () async{

    when(()=> examRepository.getExamQuestions(any()),
    ).thenAnswer((_) async=> const Right([]));

    final result = await getExamsQuestionsUseCase(tExam);

    expect(result, const Right<dynamic,List<ExamQuestion>>([]));
    verify(() => examRepository.getExamQuestions(any())).called(1);
    verifyNoMoreInteractions(examRepository);
  });

  test('should return left hand side failure', () async{

    when(()=> examRepository.getExamQuestions(any()),
    ).thenAnswer((_) async=> const Left(tFailure));

    final result = await getExamsQuestionsUseCase(tExam);

    expect(result, const Left<Failure,void>(tFailure));
    verify(() => examRepository.getExamQuestions(any())).called(1);
    verifyNoMoreInteractions(examRepository);
  });

}
