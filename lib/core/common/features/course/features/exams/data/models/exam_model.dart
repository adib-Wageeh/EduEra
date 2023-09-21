import 'dart:convert';
import 'package:education_app/core/common/features/course/features/exams/data/models/exam_question_model.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam_question.dart';
import 'package:education_app/core/utils/typedefs.dart';

class ExamModel extends Exam{

  const ExamModel({required super.id, required super.courseId,
    required super.title, required super.description,
    required super.timeLimit,super.examQuestions,
  super.imageUrl,});

  factory ExamModel.fromJson(String source){
    return ExamModel.fromUploadMap(jsonDecode(source) as DataMap);
  }

  factory ExamModel.empty(){
    return ExamModel(
      id: 'Test String',
      courseId: 'Test String',
      title: 'Test String',
      description: 'Test String',
      timeLimit: 0,
      examQuestions: [ExamQuestion.empty()],
    );
  }

  factory ExamModel.fromMap(DataMap map){

    return ExamModel(
      id:  map['id'] as String,
      courseId: map['courseId'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      timeLimit: (map['timeLimit'] as num).toInt(),
      imageUrl: map['imageUrl'] as String?,
      examQuestions: const [],
    );
  }

  factory ExamModel.fromUploadMap(DataMap map){
    return ExamModel(
      id:  map['id'] as String? ?? '',
      courseId: map['courseId'] as String? ?? '',
      title: map['title'] as String,
      description: map['Description'] as String,
      timeLimit: (map['time_seconds'] as num).toInt(),
      imageUrl: (map['image_url'] as String).isEmpty ? null:
      map['image_url'] as String,
      examQuestions: List<DataMap>.from(map['questions'] as List<dynamic>)
      .map(ExamQuestionModel.fromUploadMap,
      ).toList(),
    );
  }

  ExamModel copyWith({
    String? id,
    String? courseId,
    List<ExamQuestion>? questions,
    String? title,
    String? description,
    int? timeLimit,
    String? imageUrl,
  }) {
    return ExamModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      examQuestions: questions ?? examQuestions,
      title: title ?? this.title,
      description: description ?? this.description,
      timeLimit: timeLimit ?? this.timeLimit,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'courseId': courseId,
      'title': title,
      'description': description,
      'timeLimit': timeLimit,
      'imageUrl': imageUrl,
    };
  }

}
