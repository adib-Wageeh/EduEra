import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:education_app/src/chat/domain/entities/group.dart';
import 'package:education_app/src/chat/domain/entities/message.dart';

abstract class ChatRepo{

  const ChatRepo();

  ResultFuture<void> sendMessage(MessageEntity message);
  ResultStream<List<MessageEntity>> getMessages(String groupId);
  ResultStream<List<Group>> getGroups();
  ResultFuture<void> joinGroup(String groupId);
  ResultFuture<void> leaveGroup(String groupId);
  ResultFuture<UserModel> getUserById(String userId);
}
