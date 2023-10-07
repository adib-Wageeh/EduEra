import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/chat/domain/entities/group.dart';
import 'package:education_app/src/chat/domain/repos/chat_repo.dart';
import 'package:education_app/src/chat/domain/usecases/get_groups_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'chat_repo_mock.dart';



void main() {

  late ChatRepo chatRepo;
  late GetGroupsUseCase getGroupsUseCase;
  const failure = ServerFailure(
    code: 'unknown error',
    error: '404',
  );
  final tGroups = [
    Group.empty(),
  ];

  setUp(() {
    chatRepo = ChatRepoMock();
    getGroupsUseCase = GetGroupsUseCase(chatRepo: chatRepo);
  });

  test('should return left hand side when it receives a failure', () {

    when(
        ()=> chatRepo.getGroups(),
    ).thenAnswer((_) => Stream.value(const Left(failure)));

    final result = getGroupsUseCase.call();

    expect(result, emits(const Left<Failure,dynamic>(failure)));
    verify(()=> chatRepo.getGroups()).called(1);
    verifyNoMoreInteractions(chatRepo);

  });

  test('should return right hand side List<Group>', () {

    when(
          ()=> chatRepo.getGroups(),
    ).thenAnswer((_) => Stream.value(Right(tGroups)));

    final result = getGroupsUseCase.call();

    expect(result, emits( Right<dynamic,List<Group>>(tGroups)));
    verify(()=> chatRepo.getGroups()).called(1);
    verifyNoMoreInteractions(chatRepo);

  });

}
