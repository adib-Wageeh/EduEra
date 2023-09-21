import 'package:education_app/core/common/features/course/features/exams/domain/entities/question_choices.dart';
import 'package:equatable/equatable.dart';

class ExamQuestion extends Equatable{


  const ExamQuestion({
    required this.courseId,
    required this.id,
    required this.choices,
     required this.examId,
    required this.questionText,
    this.correctAnswer,
});

  factory ExamQuestion.empty(){
    return  ExamQuestion(
      id: 'Test String',
      examId: 'Test String',
      courseId: 'Test String',
      questionText: 'Test String',
        choices: [QuestionChoice.empty()],
        correctAnswer: 'Test String',);
  }

  final String id;
  final String courseId;
  final String examId;
  final String? correctAnswer;
  final List<QuestionChoice> choices;
  final String questionText;


  @override
  List<Object?> get props => [id,examId,courseId];



}
