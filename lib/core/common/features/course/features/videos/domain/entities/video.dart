import 'package:equatable/equatable.dart';

class Video extends Equatable{

  const Video({
  required this.id,
  required this.courseId,
  required this.videoUrl,
    required this.uploadDate,
    this.thumbnailIsAFile  = false,
  this.title,
  this.thumbnail,
    this.tutor,
});
  
  factory Video.empty(){

    return Video(id: '_empty.id',
        courseId: '_empty.courseId',
        videoUrl: '_empty.videoUrl',
        uploadDate: DateTime.now(),);
  }
  

  final String videoUrl;
  final String? thumbnail;
  final String id;
  final String? title;
  final String? tutor;
  final String courseId;
  final DateTime uploadDate;
  final bool thumbnailIsAFile;

  @override
  List<Object?> get props => [id];

}
