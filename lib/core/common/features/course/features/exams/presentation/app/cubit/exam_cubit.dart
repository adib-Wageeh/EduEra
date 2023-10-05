import 'package:bloc/bloc.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam_question.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/get_exam_questions_use_case.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/get_exams_use_case.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/get_user_course_exams_use_case.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/get_user_exams_use_case.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/submit_exam_use_case.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/update_exam_use_case.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/upload_exam_use_case.dart';

import 'package:equatable/equatable.dart';

part 'exam_state.dart';

class ExamCubit extends Cubit<ExamState> {
  ExamCubit({
    required GetExamsQuestionsUseCase getExamQuestions,
    required GetExamsUseCase getExams,
    required SubmitExamsUseCase submitExam,
    required UpdateExamsUseCase updateExam,
    required UploadExamsUseCase uploadExam,
    required GetUserCourseExamUseCase getUserCourseExams,
    required GetUserExamsUseCase getUserExams,
  })  : _getExamQuestions = getExamQuestions,
        _getExams = getExams,
        _submitExam = submitExam,
        _updateExam = updateExam,
        _uploadExam = uploadExam,
        _getUserCourseExams = getUserCourseExams,
        _getUserExams = getUserExams,
        super(const ExamInitial());

  final GetExamsQuestionsUseCase _getExamQuestions;
  final GetExamsUseCase _getExams;
  final SubmitExamsUseCase _submitExam;
  final UpdateExamsUseCase _updateExam;
  final UploadExamsUseCase _uploadExam;
  final GetUserCourseExamUseCase _getUserCourseExams;
  final GetUserExamsUseCase _getUserExams;

  Future<void> getExamQuestions(Exam exam) async {
    emit(const GettingExamQuestions());
    final result = await _getExamQuestions(exam);
    result.fold(
      (failure) => emit(ExamError(failure.errorMessage)),
      (questions) => emit(ExamQuestionsLoaded(questions)),
    );
  }

  Future<void> getExams(String courseId) async {
    emit(const GettingExams());
    final result = await _getExams(courseId);
    result.fold(
      (failure) => emit(ExamError(failure.errorMessage)),
      (exams) => emit(ExamsLoaded(exams)),
    );
  }

  Future<void> submitExam(UserExam exam) async {
    emit(const SubmittingExam());
    final result = await _submitExam(exam);
    result.fold(
      (failure) => emit(ExamError(failure.errorMessage)),
      (_) => emit(const ExamSubmitted()),
    );
  }

  Future<void> updateExam(Exam exam) async {
    emit(const UpdatingExam());
    final result = await _updateExam(exam);
    result.fold(
      (failure) => emit(ExamError(failure.errorMessage)),
      (_) => emit(const ExamUpdated()),
    );
  }

  Future<void> uploadExam(Exam exam) async {
    emit(const UploadingExam());
    final result = await _uploadExam(exam);
    result.fold(
      (failure) => emit(ExamError(failure.errorMessage)),
      (_) => emit(const ExamUploaded()),
    );
  }

  Future<void> getUserCourseExams(String courseId) async {
    emit(const GettingUserExams());
    final result = await _getUserCourseExams(courseId);
    result.fold(
      (failure) => emit(ExamError(failure.errorMessage)),
      (exams) => emit(UserCourseExamsLoaded(exams)),
    );
  }

  Future<void> getUserExams() async {
    emit(const GettingUserExams());
    final result = await _getUserExams();
    result.fold(
      (failure) => emit(ExamError(failure.errorMessage)),
      (exams) => emit(UserExamsLoaded(exams)),
    );
  }
}
