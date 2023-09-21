import 'package:education_app/core/common/features/course/features/exams/domain/entities/user_choice.dart';
import 'package:equatable/equatable.dart';

class UserExam extends Equatable{

  const UserExam({
    required this.courseId,
    required this.examId,
    required this.dateSubmitted,
    required this.examAnswers,
    required this.examImageUrl,
    required this.examTitle,
    required this.totalQuestions,
});

  factory UserExam.empty(){
    return UserExam(courseId: 'test id',
      examId: 'test id',
      dateSubmitted: DateTime.now(),
      examAnswers: const [],
      examImageUrl: 'test examImageUrl',
      examTitle: 'test examTitle',
      totalQuestions: 0,
    );
  }

  final String examId;
  final String courseId;
  final int totalQuestions;
  final String examTitle;
  final String? examImageUrl;
  final DateTime dateSubmitted;
  final List<UserChoice> examAnswers;


  @override
  List<Object?> get props => [examId,courseId];


}
