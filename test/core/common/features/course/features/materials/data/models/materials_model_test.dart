import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/common/features/course/features/materials/data/models/materials_model.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../../../fixtures/fixture.dart';

void main() {

  final tMaterialModel = ResourcesModel.empty();
  final tMap = jsonDecode(fixture('materials.json')) as DataMap;
  final tTimeStamp = Timestamp(123456, 123456);
  tMap['uploadDate'] = tTimeStamp;

  test('copy with', () {

    final newModel = tMaterialModel.copyWith(title: 'new title');

    expect(newModel.title, 'new title');
  });

  test('to map', () {

    final result = tMaterialModel.toMap()..remove('uploadDate');
    final newMap = DataMap.from(tMap)..remove('uploadDate');

    expect(result, newMap);
  });

  test('from map', () {

    final result = ResourcesModel.fromMap(tMap);

    expect(result, tMaterialModel);
  });

}
