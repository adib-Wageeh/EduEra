
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/chat/domain/entities/message.dart';
import 'package:education_app/src/chat/domain/repos/chat_repo.dart';
import 'package:education_app/src/chat/domain/usecases/get_messages_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'chat_repo_mock.dart';

void main() {

  late ChatRepo chatRepo;
  late GetMessagesUseCase getMessagesUseCase;
  const failure = ServerFailure(
    code: 'unknown error',
    error: '404',
  );
  final tMessages = [
    MessageEntity.empty(),
  ];
  const groupId = 'group_id';

  setUp(() {
    chatRepo = ChatRepoMock();
    getMessagesUseCase = GetMessagesUseCase(chatRepo: chatRepo);
  });

  test('should return left hand side when it receives a failure', () {
    when(
          ()=> chatRepo.getMessages(any()),
    ).thenAnswer((_) => Stream.value(const Left(failure)));

    final result = getMessagesUseCase.call(groupId);

    expect(result, emits(const Left<Failure,dynamic>(failure)));
    verify(()=> chatRepo.getMessages(groupId)).called(1);
    verifyNoMoreInteractions(chatRepo);

  });

  test('should return right hand side List<MessageEntity>', () {

    when(
          ()=> chatRepo.getMessages(any()),
    ).thenAnswer((_) => Stream.value(Right(tMessages)));

    final result = getMessagesUseCase.call(groupId);

    expect(result, emits( Right<dynamic,List<MessageEntity>>(tMessages)));
    verify(()=> chatRepo.getMessages(groupId)).called(1);
    verifyNoMoreInteractions(chatRepo);

  });

}
