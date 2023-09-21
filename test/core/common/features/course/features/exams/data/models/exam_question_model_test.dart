import 'dart:convert';
import 'package:education_app/core/common/features/course/features/exams/data/models/exam_question_model.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../../../../../fixtures/fixture.dart';



void main() {

  final tExam = ExamQuestionModel.empty();

  final tMap = jsonDecode(fixture('exam.json')) as DataMap;
  final tUploadedMap = jsonDecode(fixture('uploaded_exam_question.json'))
  as DataMap;

  test('fromMap test', () {

    final result = ExamQuestionModel.fromMap
      ( (tMap['questions'] as List)[0] as DataMap );
    expect(result, tExam);
  });

  test('fromUploadMap test', () {

    final result = ExamQuestionModel.fromUploadMap(tUploadedMap);

    expect(result, tExam);
  });

  test('copyWith test', () {

    final result = tExam.copyWith(id: 'id');

    expect(result.id, 'id');
  });

  test('toMap test', () {

    final result = tExam.toMap();
    final newMap = tMap..removeWhere((key, value) => (key != 'questions'));

    expect(result,(tMap['questions'] as List)[0] as DataMap );
  });


}
