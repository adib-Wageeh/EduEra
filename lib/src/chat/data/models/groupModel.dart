import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/chat/domain/entities/group.dart';

class GroupModel extends Group{

  const GroupModel({required super.courseId,
    required super.id, required super.name,
    required super.members,super.groupImage,
  super.lastMessage,super.lastMessageSenderName,
  super.lastMessageTimeStamp,});

  factory GroupModel.empty(){
    return const GroupModel(
    courseId: ''
    ,id: '', name: '',
      members: []
      , groupImage: '',);
  }

  factory GroupModel.fromMap(DataMap json){
    return GroupModel(id: json['id'] as String,
      courseId: json['courseId'] as String,
      name: json['name'] as String,
      members: List<String>.from(json['members'] as List<dynamic>),
      groupImage: json['groupImage'] as String?,
      lastMessage: json['lastMessage'] as String?,
      lastMessageSenderName: json['lastMessageSenderName'] as String?,
      lastMessageTimeStamp:
      (json['lastMessageTimeStamp'] as Timestamp?)?.toDate() ,);
  }

  DataMap toMap(){
    return {
      'id':id,
      'courseId':courseId,
      'name':name,
      'members':members,
      'groupImage':groupImage,
      'lastMessage':lastMessage,
      'lastMessageSenderName':lastMessageSenderName,
      'lastMessageTimeStamp':
      lastMessage == null ? null : FieldValue.serverTimestamp(),
    };
  }

  GroupModel copyWith({
    String? id,
    String? courseId,
    String? name,
    List<String>? members,
    String? groupImage,
    String? lastMessage,
    String? lastMessageSenderName,
    DateTime? lastMessageTimeStamp,
  }) {
    return GroupModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      name: name ?? this.name,
      members: members ?? this.members,
      groupImage: groupImage ?? this.groupImage,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageSenderName: lastMessageSenderName
          ?? this.lastMessageSenderName,
      lastMessageTimeStamp: lastMessageTimeStamp ?? this.lastMessageTimeStamp,
    );
  }

}
