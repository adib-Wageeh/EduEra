import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/common/features/course/data/models/course_model.dart';
import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../../../fixtures/fixture.dart';

void main() {

  final tCourseModel = CourseModel.empty();
  final tMap = jsonDecode(fixture('course.json')) as DataMap;
  final tTimeStamp = Timestamp(123456, 123456);
  tMap['createdAt'] = tTimeStamp;
  tMap['updatedAt'] = tTimeStamp;


  test('should be a subclass of Course entity', () {

    expect(tCourseModel, isA<Course>());

  });

  group('toMap', () {

    test('successfully converting course model toMap ', (){

      final result = tCourseModel.toMap()..remove('createdAt')
      ..remove('updatedAt');
      final newMap = DataMap.from(tMap)..remove('updatedAt')
        ..remove('createdAt');

      expect(result, newMap);
    });
  });

  group('fromMap', () {

    test('successfully converting Map to course model', (){
      final result = CourseModel.fromMap(tMap);
      expect(result, tCourseModel);
    });
  });

  group('copy with', () {

    test('successfully converting Map to course model', (){

      final result = tCourseModel.copyWith(title: 'title');

      expect(result.title, 'title');
    });
  });

}
