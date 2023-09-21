import 'dart:convert';

import 'package:education_app/core/common/features/course/features/exams/data/models/exam_model.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../../../fixtures/fixture.dart';

void main() {

   final tExam = ExamModel.empty();

   final tMap = jsonDecode(fixture('exam.json')) as DataMap;


  test('fromMap test', () {

      final result = ExamModel.fromMap(tMap);
      expect(result, tExam);
  });

   test('toMap test', () {

     final result = tExam.toMap();
     final res = tMap..remove('questions');
     expect(result, res);
   });

   test('fromJson test', () {

     final result = ExamModel.fromJson(fixture('uploaded_exam.json'));
     expect(result, tExam);
   });

   test('copywith test', () {

     final result = tExam.copyWith(id: 'id');
     expect(result.id, 'id');
   });

   test('fromUploadMap test', () {

     final tUploadMap = jsonDecode(fixture('uploaded_exam.json')) as DataMap;
     final result = ExamModel.fromUploadMap(tUploadMap);
     expect(result,tExam );
   });

}
