import 'package:education_app/core/common/features/course/features/exams/data/models/question_choices_model.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam_question.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/question_choices.dart';
import 'package:education_app/core/utils/typedefs.dart';

class ExamQuestionModel extends ExamQuestion{

  const ExamQuestionModel({required super.courseId, required super.id,
    required super.choices,  required super.examId, required super.questionText,
    super.correctAnswer,});

  factory ExamQuestionModel.empty(){
    return const ExamQuestionModel(
      courseId: 'Test String',
      id: 'Test String',
      choices: [QuestionChoiceModel.empty()],
      examId: 'Test String',
      questionText: 'Test String',
      correctAnswer: 'Test String',
    );
  }

  factory ExamQuestionModel.fromMap(DataMap map){
    return ExamQuestionModel(
      id:  map['id'] as String,
      courseId: map['courseId'] as String,
      examId: map['examId'] as String,
      questionText: map['questionText'] as String,
      correctAnswer: map['correctAnswer'] as String?,
      choices: List<DataMap>.from(
        map['choices'] as List<dynamic>,
      ).map(QuestionChoiceModel.fromMap)
      .toList(),
    );
  }

  factory ExamQuestionModel.fromUploadMap(DataMap map){
    return ExamQuestionModel(
      id: map['id'] as String? ?? '',
      courseId: map['courseId'] as String? ?? '',
      examId: map['examId'] as String? ?? '',
      correctAnswer: map['correct_answer'] as String,
      questionText: map['question'] as String,
      choices: List<DataMap>.from(map['answers'] as List<dynamic>)
        .map(QuestionChoiceModel.fromUploadMap).toList(),
    );
  }

  ExamQuestionModel copyWith({
    String? id,
    String? examId,
    String? courseId,
    String? questionText,
    List<QuestionChoice>? choices,
    String? correctAnswer,
  }) {
    return ExamQuestionModel(
      id: id ?? this.id,
      examId: examId ?? this.examId,
      courseId: courseId ?? this.courseId,
      questionText: questionText ?? this.questionText,
      choices: choices ?? this.choices,
      correctAnswer: correctAnswer ?? this.correctAnswer,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'examId': examId,
      'courseId': courseId,
      'questionText': questionText,
      'choices': choices
          .map((choice) => (choice as QuestionChoiceModel).toMap())
          .toList(),
      'correctAnswer': correctAnswer,
    };
  }



}
