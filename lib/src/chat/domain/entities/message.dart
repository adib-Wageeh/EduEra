import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable{

  const MessageEntity({
    required this.message,
    required this.id,
    required this.senderId,
    required this.groupId,
    required this.timeStamp,
  });

  factory MessageEntity.empty(){
    return MessageEntity(message: '', id: '', senderId: '', groupId: '',
        timeStamp: DateTime.now(),);
  }

  final String id;
  final String senderId;
  final DateTime timeStamp;
  final String groupId;
  final String message;

  @override
  String toString() {
    return 'Message{id: $id ,message: $message ,senderId: $senderId}';
  }

  @override
  List<Object?> get props => [id];

}
