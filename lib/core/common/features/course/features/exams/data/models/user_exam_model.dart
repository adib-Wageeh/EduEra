import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/common/features/course/features/exams/data/models/user_choice_model.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/user_choice.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/core/utils/typedefs.dart';

class UserExamModel extends UserExam{

  const UserExamModel({required super.courseId, required super.examId,
    required super.dateSubmitted, required super.examAnswers,
    required super.examImageUrl, required super.examTitle,
    required super.totalQuestions,});


  factory UserExamModel.empty(){
    return UserExamModel(
      courseId: 'Test String',
      examId: 'Test String',
      dateSubmitted: DateTime.now(),
      examAnswers: const [],
      examImageUrl: 'Test String',
        examTitle: 'Test String',
        totalQuestions: 0,
    );
  }

  UserExamModel.fromMap(DataMap map)
      : this(
    examId: map['examId'] as String,
    courseId: map['courseId'] as String,
    totalQuestions: (map['totalQuestions'] as num).toInt(),
    examTitle: map['examTitle'] as String,
    examImageUrl: map['examImageUrl'] as String?,
    dateSubmitted: (map['dateSubmitted'] as Timestamp).toDate(),
    examAnswers: List<DataMap>.from(map['answers'] as List<dynamic>)
        .map(UserChoiceModel.fromMap)
        .toList(),
  );

  UserExamModel copyWith({
    String? examId,
    String? courseId,
    int? totalQuestions,
    String? examTitle,
    String? examImageUrl,
    DateTime? dateSubmitted,
    List<UserChoice>? answers,
  }) {
    return UserExamModel(
      examId: examId ?? this.examId,
      courseId: courseId ?? this.courseId,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      examTitle: examTitle ?? this.examTitle,
      examImageUrl: examImageUrl ?? this.examImageUrl,
      dateSubmitted: dateSubmitted ?? this.dateSubmitted,
      examAnswers: answers ?? examAnswers,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'examId': examId,
      'courseId': courseId,
      'totalQuestions': totalQuestions,
      'examTitle': examTitle,
      'examImageUrl': examImageUrl,
      'dateSubmitted': FieldValue.serverTimestamp(),
      'answers':
      examAnswers.map((answer) => (answer as UserChoiceModel).toMap()).toList(),
    };
  }

}
