import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/entities/video.dart';
import 'package:education_app/core/utils/typedefs.dart';

class VideoModel extends Video{

  const VideoModel({required super.id, required super.courseId,
    required super.videoUrl, required super.uploadDate,super.thumbnail,
  super.thumbnailIsAFile,super.title,super.tutor,});

  factory VideoModel.empty(){

    return VideoModel(id: '_empty.id',
      courseId: '_empty.courseId',
      videoUrl: '_empty.videoUrl',
      uploadDate: DateTime.now(),);
  }

  factory VideoModel.fromMap(DataMap json){
    return VideoModel(id: json['id'] as String,
      courseId: json['courseId'] as String,
      videoUrl: json['videoUrl'] as String,
      uploadDate: (json['uploadDate'] as Timestamp).toDate(),
      thumbnail: json['thumbnail'] as String?,
      title: json['title'] as String?,
      tutor: json['tutor'] as String?,);
  }

  DataMap toMap(){
    return {
      'id':id,
      'courseId':courseId,
      'videoUrl':videoUrl,
      'uploadDate':FieldValue.serverTimestamp(),
      'thumbnail':thumbnail,
      'title':title,
      'tutor':tutor,
    };
  }

  VideoModel copyWith({
    String? id,
    String? courseId,
    String? videoUrl,
    DateTime? uploadDate,
    String? thumbnail,
    bool? thumbnailIsAFile,
    String? title,
    String? tutor,
  }) {
    return VideoModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      videoUrl: videoUrl ?? this.videoUrl,
      uploadDate: uploadDate ?? this.uploadDate,
      thumbnail: thumbnail ?? this.thumbnail,
      thumbnailIsAFile: thumbnailIsAFile ?? this.thumbnailIsAFile,
      title: title ?? this.title,
      tutor: tutor ?? this.tutor,
    );
  }

}
