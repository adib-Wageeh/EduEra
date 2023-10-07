
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/chat/domain/entities/message.dart';
import 'package:education_app/src/chat/domain/repos/chat_repo.dart';
import 'package:education_app/src/chat/domain/usecases/send_message_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'chat_repo_mock.dart';

void main() {

  late ChatRepo chatRepo;
  late SendMessageUseCase sendMessageUseCase;
  const failure = ServerFailure(
    code: 'unknown error',
    error: '404',
  );
  final tMessage = MessageEntity.empty();

  setUp(() {
    chatRepo = ChatRepoMock();
    sendMessageUseCase = SendMessageUseCase(chatRepo: chatRepo);
    registerFallbackValue(tMessage);
  });


  test('should return left hand side when it receives a failure', () async{
    when(
          ()=> chatRepo.sendMessage(any()),
    ).thenAnswer((_) => Future.value(const Left(failure)));

    final result = await sendMessageUseCase.call(tMessage);

    expect(result,const Left<Failure,dynamic>(failure));
    verify(()=> chatRepo.sendMessage(tMessage)).called(1);
    verifyNoMoreInteractions(chatRepo);

  });

  test('should return right hand side void', () async{

    when(
          ()=> chatRepo.sendMessage(any()),
    ).thenAnswer((_) => Future.value(const Right(null)));

    final result = await sendMessageUseCase.call(tMessage);

    expect(result,const Right<dynamic,void>(null));
    verify(()=> chatRepo.sendMessage(tMessage)).called(1);
    verifyNoMoreInteractions(chatRepo);

  });

}
