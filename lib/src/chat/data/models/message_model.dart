import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/chat/domain/entities/message.dart';

class MessageModel extends MessageEntity{

  const MessageModel({required super.message, required super.id,
    required super.senderId, required super.groupId,
    required super.timeStamp,});

  factory MessageModel.fromMap(DataMap map){
    return MessageModel(message: map['message'] as String,
        id: map['id'] as String,
        senderId: map['senderId'] as String,
        groupId: map['groupId'] as String,
        timeStamp: (map['timeStamp'] as Timestamp).toDate(),);
  }

  factory MessageModel.empty(){
    return MessageModel(message: 'message', id: 'message_id',
      senderId: 'sender_id', groupId: 'group_id',
      timeStamp: DateTime.now(),);
  }

  DataMap toMap(){
    return {
      'message': super.message,
      'id': super.id,
      'senderId': super.senderId,
      'groupId': super.groupId,
      'timeStamp': FieldValue.serverTimestamp(),
    };
  }

  MessageModel copyWith({
    String? id,
    String? message,
    String? senderId,
    String? groupId,
    DateTime? timeStamp,
  }) {
    return MessageModel(
      id: id ?? this.id,
      message: message ?? this.message,
      senderId: senderId ?? this.senderId,
      groupId: groupId ?? this.groupId,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

}
