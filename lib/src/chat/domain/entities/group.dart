import 'package:equatable/equatable.dart';

class Group extends Equatable{

  const Group({
    required this.courseId,
    required this.id,required this.name,
    required this.members, this.groupImage,this.lastMessage,
    this.lastMessageSenderName,this.lastMessageTimeStamp,
});

  factory Group.empty(){
    
    return const Group(courseId: '', id: '', name: '', members: [],);
  }
  
  final String id;
  final String courseId;
  final String name;
  final List<String> members;
  final String? lastMessage;
  final String? groupImage;
  final DateTime? lastMessageTimeStamp;
  final String? lastMessageSenderName;
  
  

  @override
  List<Object?> get props => [id,name,courseId];

}
