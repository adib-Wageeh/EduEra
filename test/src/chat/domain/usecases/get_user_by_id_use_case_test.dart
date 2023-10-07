import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:education_app/src/chat/domain/repos/chat_repo.dart';
import 'package:education_app/src/chat/domain/usecases/get_user_by_id_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'chat_repo_mock.dart';


void main() {

  late ChatRepo chatRepo;
  late GetUserByIdUseCase getUserByIdUseCase;
  const failure = ServerFailure(
    code: 'unknown error',
    error: '404',
  );
  final tUser = UserModel.empty();
  const userId = 'user_id';

  setUp(() {
    chatRepo = ChatRepoMock();
    getUserByIdUseCase = GetUserByIdUseCase(chatRepo: chatRepo);
  });

  test('should return left hand side when it receives a failure', () async{
    when(
          ()=> chatRepo.getUserById(any()),
    ).thenAnswer((_) => Future.value(const Left(failure)));

    final result = await getUserByIdUseCase.call(userId);

    expect(result,const Left<Failure,dynamic>(failure));
    verify(()=> chatRepo.getUserById(userId)).called(1);
    verifyNoMoreInteractions(chatRepo);

  });

  test('should return right hand side UserModel', () async{

    when(
          ()=> chatRepo.getUserById(any()),
    ).thenAnswer((_) => Future.value(Right(tUser)));

    final result = await getUserByIdUseCase.call(userId);

    expect(result,Right<dynamic,UserModel>(tUser));
    verify(()=> chatRepo.getUserById(userId)).called(1);
    verifyNoMoreInteractions(chatRepo);

  });

}
