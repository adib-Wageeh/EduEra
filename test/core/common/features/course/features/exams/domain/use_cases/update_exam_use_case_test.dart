import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/repos/exam_repo.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/update_exam_use_case.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'exam_repo_mock.dart';

void main() {

  late ExamRepository examRepository;
  late UpdateExamsUseCase updateExamsUseCase;
  const tFailure = ServerFailure(
    error: 'unknown error',
    code: 404,
  );
  final tExam = Exam.empty();


  setUp(() {
    examRepository = ExamRepositoryMock();
    updateExamsUseCase = UpdateExamsUseCase
      (examRepository: examRepository,);
    registerFallbackValue(tExam);
  });

  test('should return right hand side void', () async{

    when(()=> examRepository.updateExam(any()),
    ).thenAnswer((_) async=> const Right(null) );

    final result = await updateExamsUseCase(tExam);

    expect(result, const Right<dynamic,void>(null));
    verify(() => examRepository.updateExam(tExam)).called(1);
    verifyNoMoreInteractions(examRepository);
  });

  test('should return left hand side failure', () async{

    when(()=> examRepository.updateExam(any()),
    ).thenAnswer((_) async=> const Left(tFailure));

    final result = await updateExamsUseCase(tExam);

    expect(result, const Left<Failure,void>(tFailure));
    verify(() => examRepository.updateExam(tExam)).called(1);
    verifyNoMoreInteractions(examRepository);
  });

}
