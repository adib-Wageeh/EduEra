import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:education_app/src/chat/data/dataSource/chat_remote_data_source.dart';
import 'package:education_app/src/chat/data/models/group_model.dart';
import 'package:education_app/src/chat/data/models/message_model.dart';
import 'package:education_app/src/chat/domain/entities/group.dart';
import 'package:education_app/src/chat/domain/entities/message.dart';
import 'package:education_app/src/chat/domain/repos/chat_repo.dart';

class ChatRepoImpl implements ChatRepo{

  const ChatRepoImpl({required this.chatRemoteDataSource,});

  final ChatRemoteDataSource chatRemoteDataSource;

  @override
  ResultStream<List<Group>> getGroups() {
    return chatRemoteDataSource.getGroups()
        .transform(
      StreamTransformer<List<GroupModel>,
          Either<Failure, List<Group>>>.fromHandlers(
        handleData: (data,sink){
          sink.add(Right(data));
        },
        handleError: (error,_,sink){
          if(error is ServerException){
            sink.add(Left(ServerFailure.fromException(error)));
          }else{
            sink.add(Left(ServerFailure(
              error: error.toString(),
              code: 505,
            ),),);

          }
        },
      ),
    );
  }

  @override
  ResultStream<List<MessageEntity>> getMessages(String groupId) {

    return chatRemoteDataSource.getMessages(groupId)
        .transform(
      StreamTransformer<List<MessageModel>,
          Either<Failure, List<MessageEntity>>>.fromHandlers(
        handleData: (data,sink){
          sink.add(Right(data));
        },
        handleError: (error,stack,sink){
          if(error is ServerException){
            sink.add(Left(ServerFailure.fromException(error)));
          }else{
            sink.add(Left(ServerFailure(
              error: error.toString(),
              code: 505,
            ),),);

          }
        },
      ),
    );

  }

  @override
  ResultFuture<UserModel> getUserById(String userId) async{
    try{
      final result = await chatRemoteDataSource.getUserById(userId);
      return Right(result);
    }on ServerException catch(e){
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> joinGroup(String groupId) async{
    try{
      await chatRemoteDataSource.joinGroup(groupId);
      return const Right(null);
    }on ServerException catch(e){
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> leaveGroup(String groupId) async{
    try{
      await chatRemoteDataSource.leaveGroup(groupId);
      return const Right(null);
    }on ServerException catch(e){
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> sendMessage(MessageEntity message) async{
   try{
     await chatRemoteDataSource.sendMessage(message);
     return const Right(null);
   }on ServerException catch(e){
     return Left(ServerFailure.fromException(e));
   }
  }


}
