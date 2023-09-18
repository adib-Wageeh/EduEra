import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/common/features/course/features/videos/data/models/video_model.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/entities/video.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../../../fixtures/fixture.dart';


void main() {

  final tVideoModel = VideoModel.empty();
  final tMap = jsonDecode(fixture('video.json')) as DataMap;
  final tTimeStamp = Timestamp(123456, 123456);
  tMap['uploadDate'] = tTimeStamp;


  test('should be a subclass of Video entity', () {

    expect(tVideoModel, isA<Video>());
  });

  test('copy with functionality', () {

    final result = tVideoModel.copyWith(title: 'new title');

    expect(result.title, 'new title');

  });

  test('from map functionality', () {

    final tModel = VideoModel.fromMap(tMap);

    expect(tModel, tVideoModel);

  });

  test('to map functionality', () {

    final result = tVideoModel.toMap()..remove('uploadDate');
    final newMap = DataMap.from(tMap)..remove('uploadDate');

    expect(result, newMap);

  });

}
