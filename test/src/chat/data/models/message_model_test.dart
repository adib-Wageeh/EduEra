
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/chat/data/models/message_model.dart';
import 'package:education_app/src/chat/domain/entities/message.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture.dart';

void main() {

  final messageMap = jsonDecode(fixture('message.json')) as DataMap;
  messageMap['timeStamp'] = Timestamp(123456, 123456);

  final tMessage = MessageModel.empty();


  test('MessageModel is subtype of MessageEntity', () {
    expect(tMessage, isA<MessageEntity>());
  });

  test('copy with test', () {

    final result = tMessage.copyWith(message: 'hello');
    expect(result.message, 'hello');
  });

  test('fromMap test', () {

    final result = MessageModel.fromMap(messageMap);

    expect(result,tMessage);
  });

  test('toMap test', () {

    final result = tMessage.toMap();
    result['timeStamp'] = Timestamp(123456, 123456);

    expect(result,messageMap);
  });

}
