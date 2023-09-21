import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/repos/exam_repo.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/submit_exam_use_case.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'exam_repo_mock.dart';

void main() {

  late ExamRepository examRepository;
  late SubmitExamsUseCase submitExamsUseCase;
  const tFailure = ServerFailure(
    error: 'unknown error',
    code: 404,
  );
  final tUserExam = UserExam.empty();


  setUp(() {
    examRepository = ExamRepositoryMock();
    submitExamsUseCase = SubmitExamsUseCase
      (examRepository: examRepository,);
    registerFallbackValue(tUserExam);
  });

  test('should return right hand side void', () async{

    when(()=> examRepository.submitExam(any()),
    ).thenAnswer((_) async=> const Right(null) );

    final result = await submitExamsUseCase(tUserExam);

    expect(result, const Right<dynamic,void>(null));
    verify(() => examRepository.submitExam(tUserExam)).called(1);
    verifyNoMoreInteractions(examRepository);
  });

  test('should return left hand side failure', () async{

    when(()=> examRepository.submitExam(any()),
    ).thenAnswer((_) async=> const Left(tFailure));

    final result = await submitExamsUseCase(tUserExam);

    expect(result, const Left<Failure,void>(tFailure));
    verify(() => examRepository.submitExam(tUserExam)).called(1);
    verifyNoMoreInteractions(examRepository);
  });

}
