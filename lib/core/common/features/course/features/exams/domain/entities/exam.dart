import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam_question.dart';
import 'package:equatable/equatable.dart';

class Exam extends Equatable{

  const Exam({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
     required this.timeLimit,
    this.examQuestions,
     this.imageUrl,
});

  factory Exam.empty(){
    return const Exam(courseId: 'test id',
      id: 'test id',
      title: 'test title',
      description: 'test description',
      timeLimit: 0,);
  }

  final String id;
  final String courseId;
  final String title;
  final String? imageUrl;
  final String description;
  final int timeLimit;
  final List<ExamQuestion>? examQuestions;

  @override
  List<Object?> get props => [id,courseId];


}

