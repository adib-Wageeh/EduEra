import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:education_app/src/chat/data/dataSource/chat_remote_data_source.dart';
import 'package:education_app/src/chat/data/models/group_model.dart';
import 'package:education_app/src/chat/data/models/message_model.dart';
import 'package:education_app/src/chat/data/repos/chat_repo_impl.dart';
import 'package:education_app/src/chat/domain/entities/group.dart';
import 'package:education_app/src/chat/domain/entities/message.dart';
import 'package:education_app/src/chat/domain/repos/chat_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ChatRemoteDataSourceMock extends Mock implements ChatRemoteDataSource{}

void main() {

  late ChatRemoteDataSource chatRemoteDataSource;
  late ChatRepo chatRepo;
  final messageEntity = MessageEntity.empty();
  const tException = ServerException(error: 'unexpected exception',
      code: '404',);
  const groupId = 'group_id';
  const userId = 'user_id';
  final userModel = UserModel.empty();
  final messages = [
    MessageModel.empty(),
    MessageModel.empty(),
  ];
  final groups = [
    GroupModel.empty(),
    GroupModel.empty(),
  ];

  setUp(() {
    chatRemoteDataSource = ChatRemoteDataSourceMock();
    chatRepo = ChatRepoImpl(chatRemoteDataSource: chatRemoteDataSource);
    registerFallbackValue(messageEntity);
  });

  group('send message', () {

    test('should return right hand side when no exception is thrown', ()async{

      when(
          ()=> chatRemoteDataSource.sendMessage(any()),
      ).thenAnswer((_) => Future.value());

      final result = await chatRepo.sendMessage(messageEntity);

      expect(result, const Right<dynamic,void>(null));
      verify(
          ()=> chatRemoteDataSource.sendMessage(messageEntity)
      ,).called(1);
      verifyNoMoreInteractions(chatRemoteDataSource);
    });

    test('should return left hand side when exception is thrown', () async{
      when(
            ()=> chatRemoteDataSource.sendMessage(any()),
      ).thenThrow(tException);

      final result = await chatRepo.sendMessage(messageEntity);

      expect(result,
          Left<Failure,dynamic>(ServerFailure.fromException(tException)),);
      verify(
            ()=> chatRemoteDataSource.sendMessage(messageEntity)
        ,).called(1);
      verifyNoMoreInteractions(chatRemoteDataSource);
    });

  });

  group('leaveGroup', () {

    test('should return right hand side when no exception is thrown', ()async{

      when(
            ()=> chatRemoteDataSource.leaveGroup(any()),
      ).thenAnswer((_) => Future.value());

      final result = await chatRepo.leaveGroup(groupId);

      expect(result, const Right<dynamic,void>(null));
      verify(
            ()=> chatRemoteDataSource.leaveGroup(groupId)
        ,).called(1);
      verifyNoMoreInteractions(chatRemoteDataSource);
    });

    test('should return left hand side when exception is thrown', () async{
      when(
            ()=> chatRemoteDataSource.leaveGroup(any()),
      ).thenThrow(tException);

      final result = await chatRepo.leaveGroup(groupId);

      expect(result,
        Left<Failure,dynamic>(ServerFailure.fromException(tException)),);
      verify(
            ()=> chatRemoteDataSource.leaveGroup(groupId)
        ,).called(1);
      verifyNoMoreInteractions(chatRemoteDataSource);
    });

  });

  group('joinGroup', () {

    test('should return right hand side when no exception is thrown', ()async{

      when(
            ()=> chatRemoteDataSource.joinGroup(any()),
      ).thenAnswer((_) => Future.value());

      final result = await chatRepo.joinGroup(groupId);

      expect(result, const Right<dynamic,void>(null));
      verify(
            ()=> chatRemoteDataSource.joinGroup(groupId)
        ,).called(1);
      verifyNoMoreInteractions(chatRemoteDataSource);
    });

    test('should return left hand side when exception is thrown', () async{
      when(
            ()=> chatRemoteDataSource.joinGroup(any()),
      ).thenThrow(tException);

      final result = await chatRepo.joinGroup(groupId);

      expect(result,
        Left<Failure,dynamic>(ServerFailure.fromException(tException)),);
      verify(
            ()=> chatRemoteDataSource.joinGroup(groupId)
        ,).called(1);
      verifyNoMoreInteractions(chatRemoteDataSource);
    });

  });

  group('getUserById', () {

    test('should return right hand side when no exception is thrown', ()async{

      when(
            ()=> chatRemoteDataSource.getUserById(any()),
      ).thenAnswer((_) => Future.value(userModel));

      final result = await chatRepo.getUserById(userId);

      expect(result, Right<dynamic,UserModel>(userModel));
      verify(
            ()=> chatRemoteDataSource.getUserById(userId)
        ,).called(1);
      verifyNoMoreInteractions(chatRemoteDataSource);
    });

    test('should return left hand side when exception is thrown', () async{
      when(
            ()=> chatRemoteDataSource.getUserById(any()),
      ).thenThrow(tException);

      final result = await chatRepo.getUserById(userId);

      expect(result,
        Left<Failure,dynamic>(ServerFailure.fromException(tException)),);
      verify(
            ()=> chatRemoteDataSource.getUserById(userId)
        ,).called(1);
      verifyNoMoreInteractions(chatRemoteDataSource);
    });

  });

  group('getMessages', () {

    test('should emit right hand side when it receives data successfully'
        , ()async{

      when(
            ()=> chatRemoteDataSource.getMessages(any()),
      ).thenAnswer((_) => Stream.value(messages));

      final result = chatRepo.getMessages(userId);

      expect(result, emits(Right<dynamic,List<MessageEntity>>(messages)));
      verify(
            ()=> chatRemoteDataSource.getMessages(userId)
        ,).called(1);
      verifyNoMoreInteractions(chatRemoteDataSource);
    });

    test('should emit left hand side when stream throws a serverException'
        , () async{
      when(
            ()=> chatRemoteDataSource.getMessages(any()),
      ).thenAnswer((_) => Stream.error(tException));

      final result = chatRepo.getMessages(userId);

      expect(result,emits(
        Left<Failure,dynamic>(ServerFailure.fromException(tException)),),);
      verify(
            ()=> chatRemoteDataSource.getMessages(userId)
        ,).called(1);
      verifyNoMoreInteractions(chatRemoteDataSource);
    });

  });

  group('getGroups', () {

    test('should emit right hand side when it receives data successfully'
        , ()async{

          when(
                ()=> chatRemoteDataSource.getGroups(),
          ).thenAnswer((_) => Stream.value(groups));

          final result = chatRepo.getGroups();

          expect(result, emits(Right<dynamic,List<Group>>(groups)));
          verify(
                ()=> chatRemoteDataSource.getGroups()
            ,).called(1);
          verifyNoMoreInteractions(chatRemoteDataSource);
        });

    test('should emit left hand side when stream throws a serverException'
        , () async{
          when(
                ()=> chatRemoteDataSource.getGroups(),
          ).thenAnswer((_) => Stream.error(tException));

          final result = chatRepo.getGroups();

          expect(result,emits(
            Left<Failure,dynamic>(ServerFailure.fromException(tException)),),);
          verify(
                ()=> chatRemoteDataSource.getGroups()
            ,).called(1);
          verifyNoMoreInteractions(chatRemoteDataSource);
        });

  });

}
