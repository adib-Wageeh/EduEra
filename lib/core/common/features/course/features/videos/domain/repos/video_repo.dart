import 'package:education_app/core/common/features/course/features/videos/domain/entities/video.dart';
import 'package:education_app/core/utils/typedefs.dart';

abstract class VideoRepository{

  const VideoRepository();
  
  ResultFuture<List<Video>> getVideos(String courseId);

  ResultFuture<void> addVideo(Video video);


}
