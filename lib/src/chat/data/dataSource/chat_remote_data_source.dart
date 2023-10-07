import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:education_app/src/chat/data/models/group_model.dart';
import 'package:education_app/src/chat/data/models/message_model.dart';
import 'package:education_app/src/chat/domain/entities/message.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ChatRemoteDataSource{

  Future<void> sendMessage(MessageEntity message);
  Stream<List<MessageModel>> getMessages(String groupId);
  Stream<List<GroupModel>> getGroups();
  Future<void> joinGroup(String groupId);
  Future<void> leaveGroup(String groupId);
  Future<UserModel> getUserById(String userId);

}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource{

  const ChatRemoteDataSourceImpl(
  {required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
}):
  _auth = firebaseAuth,
  _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Stream<List<GroupModel>> getGroups() {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const ServerException
          (code: '401', error: 'user is not authenticated');
      }
      final notificationStream = _firestore.collection('groups').snapshots()
        .map((groups)=> groups.docs.map((group) {
          return GroupModel.fromMap(group.data());
      }).toList(),);

      return notificationStream.handleError((dynamic error){
        if (error is FirebaseException) {
          throw ServerException(
            error: error.message ?? 'Unknown error occurred',
            code: error.code,
          );
        }
        throw ServerException(error: error.toString(), code: '505');
      });

    }on FirebaseException catch(e){
      return Stream.error(ServerException
        (code: e.code,error: e.message??'unknown error occurred'),);
    } on ServerException catch(e){
      return Stream.error(e);
    }catch(e){
      return Stream.error(ServerException
        (code: '505',error: e.toString()),);
    }

    }

  @override
  Stream<List<MessageModel>> getMessages(String groupId) {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const ServerException
          (code: '401', error: 'user is not authenticated');
      }

      final notificationStream = _firestore.collection('groups')
          .doc(groupId).collection('messages')
          .orderBy('timeStamp').snapshots()
          .map((messages)=> messages.docs.map((message) {
        return MessageModel.fromMap(message.data());
      }).toList(),);

      return notificationStream.handleError((dynamic error){
        if (error is FirebaseException) {
          throw ServerException(
            error: error.message ?? 'Unknown error occurred',
            code: error.code,
          );
        }
        throw ServerException(error: error.toString(), code: '505');
      });

    }on FirebaseException catch(e){
      return Stream.error(ServerException
        (code: e.code,error: e.message??'unknown error occurred'),);
    } on ServerException catch(e){
      return Stream.error(e);
    }catch(e){
      return Stream.error(ServerException
        (code: '505',error: e.toString()),);
    }
  }

  @override
  Future<UserModel> getUserById(String userId) async{
    try{
      final user = _auth.currentUser;
      if (user == null) {
        throw const ServerException
          (code: '401', error: 'user is not authenticated');
      }

      final userDoc = await _firestore.collection('users')
        .doc(userId).get();

      return UserModel.fromMap(userDoc.data()!);

    }on FirebaseException catch(e){
      throw ServerException
        (code: e.code,error: e.message??'unknown error occurred');
    } on ServerException {
      rethrow;
    }catch(e){
      throw ServerException
        (code: '505',error: e.toString());
    }
  }

  @override
  Future<void> joinGroup(String groupId) async{

    try{

      final user = _auth.currentUser;
      if (user == null) {
        throw const ServerException
          (code: '401', error: 'user is not authenticated');
      }
      await _firestore.collection('groups')
        .doc(groupId).update({
        'members': FieldValue.arrayUnion([user.uid]),
      });

      await _firestore.collection('users')
          .doc(user.uid).update({
        'joinedGroupsIds': FieldValue.arrayUnion([groupId]),
      });

    }on FirebaseException catch(e){
      throw ServerException
        (code: e.code,error: e.message??'unknown error occurred');
    } on ServerException catch(e){
      rethrow;
    }catch(e){
      throw ServerException
        (code: '505',error: e.toString());
    }
  }

  @override
  Future<void> leaveGroup(String groupId) async{
    try{
      final user = _auth.currentUser;
      if (user == null) {
        throw const ServerException
          (code: '401', error: 'user is not authenticated');
      }

      await _firestore.collection('groups')
          .doc(groupId).update({
        'members': FieldValue.arrayRemove([user.uid]),
      });

      await _firestore.collection('users')
          .doc(user.uid).update({
        'joinedGroupsIds': FieldValue.arrayRemove([groupId]),
      });

    }on FirebaseException catch(e){
      throw ServerException
        (code: e.code,error: e.message??'unknown error occurred');
    } on ServerException catch(e){
      rethrow;
    }catch(e){
      throw ServerException
        (code: '505',error: e.toString());
    }
  }

  @override
  Future<void> sendMessage(MessageEntity message) async{

    try{
      final user = _auth.currentUser;
      if (user == null) {
        throw const ServerException
          (code: '401', error: 'user is not authenticated');
      }

     final messageDoc = await _firestore.collection('groups')
        .doc(message.groupId).collection('messages')
        .add( (message as MessageModel).toMap());

      final userModel = await getUserById(_auth.currentUser!.uid);
      await _firestore.collection('groups')
          .doc(message.groupId).collection('messages')
          .doc(messageDoc.id).update(
        {
          'lastMessage': message.message,
          'lastMessageTimeStamp': Timestamp.fromDate(message.timeStamp),
          'lastMessageSenderName': userModel.fullName,
        });

    }on FirebaseException catch(e){
      throw ServerException
        (code: e.code,error: e.message??'unknown error occurred');
    } on ServerException{
      rethrow;
    }catch(e){
      throw ServerException
        (code: '505',error: e.toString());
    }

  }


}
