
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/chat/domain/repos/chat_repo.dart';
import 'package:education_app/src/chat/domain/usecases/join_group_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'chat_repo_mock.dart';

void main() {

  late ChatRepo chatRepo;
  late JoinGroupUseCase joinGroupUseCase;
  const failure = ServerFailure(
    code: 'unknown error',
    error: '404',
  );
  const groupId = 'group_id';

  setUp(() {
    chatRepo = ChatRepoMock();
    joinGroupUseCase = JoinGroupUseCase(chatRepo: chatRepo);
  });

  test('should return left hand side when it receives a failure', () async{
    when(
          ()=> chatRepo.joinGroup(any()),
    ).thenAnswer((_) => Future.value(const Left(failure)));

    final result = await joinGroupUseCase.call(groupId);

    expect(result,const Left<Failure,dynamic>(failure));
    verify(()=> chatRepo.joinGroup(groupId)).called(1);
    verifyNoMoreInteractions(chatRepo);

  });

  test('should return right hand side void', () async{

    when(
          ()=> chatRepo.joinGroup(any()),
    ).thenAnswer((_) => Future.value(const Right(null)));

    final result = await joinGroupUseCase.call(groupId);

    expect(result,const Right<dynamic,void>(null));
    verify(()=> chatRepo.joinGroup(groupId)).called(1);
    verifyNoMoreInteractions(chatRepo);

  });

}
