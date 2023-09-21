
import 'dart:convert';

import 'package:education_app/core/common/features/course/features/exams/data/models/question_choices_model.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../../../../../fixtures/fixture.dart';

void main() {

  const tExam = QuestionChoiceModel.empty();

  final tMap = jsonDecode(fixture('exam.json')) as DataMap;
  final tUploadedMap = jsonDecode(fixture('uploaded_exam_question_choice.json'))
  as DataMap;

  test('fromMap test', () {

    final result = QuestionChoiceModel.fromMap
      ( (((tMap['questions'] as List)[0] as DataMap)
    ['choices'] as List)[0] as DataMap,);
    expect(result, tExam);
  });

  test('fromUploadMap test', () {

    final result = QuestionChoiceModel.fromUploadMap(tUploadedMap);

    expect(result, tExam);
  });

  test('copyWith test', () {

    final result = tExam.copyWith(identifier: 'id');

    expect(result.identifier, 'id');
  });

  test('toMap test', () {

    final result = tExam.toMap();
    final newMap = tMap..removeWhere((key, value) => (key != 'questions'));
    final choiceMap = ((newMap['questions'] as List)[0]
    as DataMap)..removeWhere((key, value) => (key != 'choices'));

    expect(result,(choiceMap['choices'] as List)[0] as DataMap );
  });
}
