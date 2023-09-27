import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/enums/notification.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/notification/data/models/notification_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture.dart';

void main() {

  final timestampData = {
    '_seconds': 1677483548,
    '_nanoseconds': 123456000,
  };

  final date =
  DateTime.fromMillisecondsSinceEpoch(timestampData['_seconds']!).add(
    Duration(microseconds: timestampData['_nanoseconds']!),
  );

  final timestamp = Timestamp.fromDate(date);

  late final tMap = jsonDecode(fixture('notification.json')) as DataMap;
  tMap['sentAt'] = timestamp;

  final tNotification = NotificationModel.empty();

  setUp(() {


  });

  group('empty', () {
    test('should return an empty [NotificationModel]', () {
      final result = NotificationModel.empty();

      expect(result.title, '_empty.title');
    });
  });


  test('from map test', () {

    final result = NotificationModel.fromMap(tMap);
    expect(result, tNotification);
  });


  test('toMap test', () {

    final result = tNotification.toMap()..remove('sentAt');

    expect(result, tMap..remove('sentAt'));
  });

  group('copyWith', () {
    test('should return a [NotificationModel] with the right data', () {
      final result = tNotification.copyWith(
        category: NotificationCategory.TEST,
      );

      expect(result, isA<NotificationModel>());
      expect(result.category, equals(NotificationCategory.TEST));
    });
  });

}
