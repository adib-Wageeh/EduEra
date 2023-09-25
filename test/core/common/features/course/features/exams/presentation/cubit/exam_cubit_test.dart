import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/features/exams/data/models/exam_model.dart';
import 'package:education_app/core/common/features/course/features/exams/data/models/user_exam_model.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/get_exam_questions_use_case.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/get_exams_use_case.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/get_user_course_exams_use_case.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/get_user_exams_use_case.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/submit_exam_use_case.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/update_exam_use_case.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/upload_exam_use_case.dart';
import 'package:education_app/core/common/features/course/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetExamQuestions extends Mock implements GetExamsQuestionsUseCase {}
class MockGetExams extends Mock implements GetExamsUseCase {}
class MockSubmitExam extends Mock implements SubmitExamsUseCase {}
class MockUpdateExam extends Mock implements UpdateExamsUseCase {}
class MockUploadExam extends Mock implements UploadExamsUseCase {}
class MockGetUserCourseExams extends Mock implements GetUserCourseExamUseCase {}
class MockGetUserExams extends Mock implements GetUserExamsUseCase {}

void main() {

late GetExamsQuestionsUseCase getExamsQuestionsUseCase;
late GetExamsUseCase getExamsUseCase;
late SubmitExamsUseCase submitExamsUseCase;
late UpdateExamsUseCase updateExamsUseCase;
late UploadExamsUseCase uploadExamsUseCase;
late GetUserCourseExamUseCase getUserCourseExamUseCase;
late GetUserExamsUseCase getUserExamsUseCase;
late ExamCubit examCubit;

final tExam = Exam.empty();
const tFailure = ServerFailure(
  error: 'unknown error',
  code: 404,
);

setUp(() {

  getExamsQuestionsUseCase = MockGetExamQuestions();
  getExamsUseCase = MockGetExams();
  submitExamsUseCase = MockSubmitExam();
  updateExamsUseCase = MockUpdateExam();
  uploadExamsUseCase = MockUploadExam();
  getUserCourseExamUseCase = MockGetUserCourseExams();
  getUserExamsUseCase = MockGetUserExams();
  examCubit = ExamCubit(getExamQuestions: getExamsQuestionsUseCase,
      getExams: getExamsUseCase, submitExam: submitExamsUseCase,
      updateExam: updateExamsUseCase,
      uploadExam: uploadExamsUseCase,
      getUserCourseExams: getUserCourseExamUseCase,
      getUserExams: getUserExamsUseCase,);
  registerFallbackValue(tExam);
});


test('initial state should be ExamInitial', () {
  expect(examCubit.state, const ExamInitial());
});

group('getExamsQuestionsUseCase', () {

  blocTest<ExamCubit,ExamState>('should return exam questions',
    build: (){
    when(
        ()=> getExamsQuestionsUseCase(any()),
    ).thenAnswer((_) async=> const Right([]));
    return examCubit;
  },
    act: (bloc)=> bloc.getExamQuestions(tExam),
  expect: ()=>[
    const GettingExamQuestions(),
    const ExamQuestionsLoaded([]),

  ],
  );


});


group('getExams', () {
  const tCourseId = 'Test String';

  blocTest<ExamCubit, ExamState>(
    'should emit [GettingExams, ExamsLoaded] when successful',
    build: () {
      when(() => getExamsUseCase(any())).thenAnswer(
            (_) async => Right([tExam]),
      );
      return examCubit;
    },
    act: (cubit) => cubit.getExams(tCourseId),
    expect: () => [
      const GettingExams(),
      ExamsLoaded([tExam]),
    ],
    verify: (_) {
      verify(() => getExamsUseCase(tCourseId)).called(1);
      verifyNoMoreInteractions(getExamsUseCase);
    },
  );

  blocTest<ExamCubit, ExamState>(
    'should emit [GettingExams, ExamError] when unsuccessful',
    build: () {
      when(() => getExamsUseCase(tCourseId))
          .thenAnswer((_) async => const Left(tFailure));
      return examCubit;
    },
    act: (cubit) => cubit.getExams(tCourseId),
    expect: () => [
      const GettingExams(),
      ExamError(tFailure.errorMessage),
    ],
    verify: (_) {
      verify(() => getExamsUseCase(tCourseId)).called(1);
      verifyNoMoreInteractions(getExamsUseCase);
    },
  );
});

group('submitExam', () {
  final tUserExam = UserExamModel.empty();

  setUp(() => registerFallbackValue(tUserExam));

  blocTest<ExamCubit, ExamState>(
    'should emit [SubmittingExam, ExamSubmitted] when successful',
    build: () {
      when(() => submitExamsUseCase(any())).thenAnswer(
            (_) async => const Right(null),
      );
      return examCubit;
    },
    act: (cubit) => cubit.submitExam(tUserExam),
    expect: () => [
      const SubmittingExam(),
      const ExamSubmitted(),
    ],
    verify: (_) {
      verify(() => submitExamsUseCase(tUserExam)).called(1);
      verifyNoMoreInteractions(submitExamsUseCase);
    },
  );

  blocTest<ExamCubit, ExamState>(
    'should emit [SubmittingExam, ExamError] when unsuccessful',
    build: () {
      when(() => submitExamsUseCase(tUserExam))
          .thenAnswer((_) async => const Left(tFailure));
      return examCubit;
    },
    act: (cubit) => cubit.submitExam(tUserExam),
    expect: () => [
      const SubmittingExam(),
      ExamError(tFailure.errorMessage),
    ],
    verify: (_) {
      verify(() => submitExamsUseCase(tUserExam)).called(1);
      verifyNoMoreInteractions(submitExamsUseCase);
    },
  );
});

group('updateExam', () {
  final tExam = ExamModel.empty();

  setUp(() => registerFallbackValue(tExam));

  blocTest<ExamCubit, ExamState>(
    'should emit [UpdatingExam, ExamUpdated] when successful',
    build: () {
      when(() => updateExamsUseCase(any())).thenAnswer(
            (_) async => const Right(null),
      );
      return examCubit;
    },
    act: (cubit) => cubit.updateExam(tExam),
    expect: () => [
      const UpdatingExam(),
      const ExamUpdated(),
    ],
    verify: (_) {
      verify(() => updateExamsUseCase(tExam)).called(1);
      verifyNoMoreInteractions(updateExamsUseCase);
    },
  );

  blocTest<ExamCubit, ExamState>(
    'should emit [UpdatingExam, ExamError] when unsuccessful',
    build: () {
      when(() => updateExamsUseCase(tExam)).thenAnswer((_)
      async => const Left(tFailure),);
      return examCubit;
    },
    act: (cubit) => cubit.updateExam(tExam),
    expect: () => [
      const UpdatingExam(),
      ExamError(tFailure.errorMessage),
    ],
    verify: (_) {
      verify(() => updateExamsUseCase(tExam)).called(1);
      verifyNoMoreInteractions(updateExamsUseCase);
    },
  );
});

group('uploadExam', () {
  final tExam = ExamModel.empty();

  setUp(() => registerFallbackValue(tExam));

  blocTest<ExamCubit, ExamState>(
    'should emit [UploadingExam, ExamUploaded] when successful',
    build: () {
      when(() => uploadExamsUseCase(any())).thenAnswer(
            (_) async => const Right(null),
      );
      return examCubit;
    },
    act: (cubit) => cubit.uploadExam(tExam),
    expect: () => [
      const UploadingExam(),
      const ExamUploaded(),
    ],
    verify: (_) {
      verify(() => uploadExamsUseCase(tExam)).called(1);
      verifyNoMoreInteractions(uploadExamsUseCase);
    },
  );

  blocTest<ExamCubit, ExamState>(
    'should emit [UploadingExam, ExamError] when unsuccessful',
    build: () {
      when(() => uploadExamsUseCase(tExam)).thenAnswer((_)
      async => const Left(tFailure),);
      return examCubit;
    },
    act: (cubit) => cubit.uploadExam(tExam),
    expect: () => [
      const UploadingExam(),
      ExamError(tFailure.errorMessage),
    ],
    verify: (_) {
      verify(() => uploadExamsUseCase(tExam)).called(1);
      verifyNoMoreInteractions(uploadExamsUseCase);
    },
  );
});

group('getUserCourseExams', () {
  const tCourseId = 'Test String';

  final tUserExams = [UserExamModel.empty()];

  blocTest<ExamCubit, ExamState>(
    'should emit [GettingUserExams, UserCourseExamsLoaded] '
        'when successful',
    build: () {
      when(() => getUserCourseExamUseCase(any())).thenAnswer(
            (_) async => Right(tUserExams),
      );
      return examCubit;
    },
    act: (cubit) => cubit.getUserCourseExams(tCourseId),
    expect: () => [
      const GettingUserExams(),
      UserCourseExamsLoaded(tUserExams),
    ],
    verify: (_) {
      verify(() => getUserCourseExamUseCase(tCourseId)).called(1);
      verifyNoMoreInteractions(getUserCourseExamUseCase);
    },
  );

  blocTest<ExamCubit, ExamState>(
    'should emit [GettingUserExams, ExamError] when unsuccessful',
    build: () {
      when(() => getUserCourseExamUseCase(tCourseId))
          .thenAnswer((_) async => const Left(tFailure));
      return examCubit;
    },
    act: (cubit) => cubit.getUserCourseExams(tCourseId),
    expect: () => [
      const GettingUserExams(),
      ExamError(tFailure.errorMessage),
    ],
    verify: (_) {
      verify(() => getUserCourseExamUseCase(tCourseId)).called(1);
      verifyNoMoreInteractions(getUserCourseExamUseCase);
    },
  );
});

group('getUserExams', () {
  final tUserExams = [UserExamModel.empty()];

  blocTest<ExamCubit, ExamState>(
    'should emit [GettingUserExams, UserExamsLoaded] when successful',
    build: () {
      when(() => getUserExamsUseCase()).thenAnswer(
            (_) async => Right(tUserExams),
      );
      return examCubit;
    },
    act: (cubit) => cubit.getUserExams(),
    expect: () => [
      const GettingUserExams(),
      UserExamsLoaded(tUserExams),
    ],
    verify: (_) {
      verify(() => getUserExamsUseCase()).called(1);
      verifyNoMoreInteractions(getUserExamsUseCase);
    },
  );

  blocTest<ExamCubit, ExamState>(
    'should emit [GettingUserExams, ExamError] when unsuccessful',
    build: () {
      when(() => getUserExamsUseCase()).thenAnswer((_)
      async => const Left(tFailure),);
      return examCubit;
    },
    act: (cubit) => cubit.getUserExams(),
    expect: () => [
      const GettingUserExams(),
      ExamError(tFailure.errorMessage),
    ],
    verify: (_) {
      verify(() => getUserExamsUseCase()).called(1);
      verifyNoMoreInteractions(getUserExamsUseCase);
    },
  );
});

}
