import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam_question.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/core/utils/typedefs.dart';

abstract class ExamRepository{

  ResultFuture<List<Exam>> getExams(String courseId);
  ResultFuture<List<ExamQuestion>> getExamQuestions(Exam exam);
  ResultFuture<void> uploadExam(Exam exam);
  ResultFuture<void> updateExam(Exam exam);
  ResultFuture<void> submitExam(UserExam exam);
  ResultFuture<List<UserExam>> getUserExams();
  ResultFuture<List<UserExam>> getUserCourseExams(String courseId);

}
