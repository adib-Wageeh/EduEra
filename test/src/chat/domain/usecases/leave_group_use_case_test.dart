import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/chat/domain/repos/chat_repo.dart';
import 'package:education_app/src/chat/domain/usecases/leave_group_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'chat_repo_mock.dart';

void main() {

  late ChatRepo chatRepo;
  late LeaveGroupUseCase leaveGroupUseCase;
  const failure = ServerFailure(
    code: 'unknown error',
    error: '404',
  );
  const groupId = 'group_id';

  setUp(() {
    chatRepo = ChatRepoMock();
    leaveGroupUseCase = LeaveGroupUseCase(chatRepo: chatRepo);
  });

  test('should return left hand side when it receives a failure', () async{
    when(
          ()=> chatRepo.leaveGroup(any()),
    ).thenAnswer((_) => Future.value(const Left(failure)));

    final result = await leaveGroupUseCase.call(groupId);

    expect(result,const Left<Failure,dynamic>(failure));
    verify(()=> chatRepo.leaveGroup(groupId)).called(1);
    verifyNoMoreInteractions(chatRepo);

  });

  test('should return right hand side void', () async{

    when(
          ()=> chatRepo.leaveGroup(any()),
    ).thenAnswer((_) => Future.value(const Right(null)));

    final result = await leaveGroupUseCase.call(groupId);

    expect(result,const Right<dynamic,void>(null));
    verify(()=> chatRepo.leaveGroup(groupId)).called(1);
    verifyNoMoreInteractions(chatRepo);

  });

}
