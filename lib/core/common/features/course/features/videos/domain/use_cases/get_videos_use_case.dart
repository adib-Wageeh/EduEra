import 'package:education_app/core/common/features/course/features/videos/domain/entities/video.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/repos/video_repo.dart';
import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';

class GetVideosUseCase extends UseCaseWithParams<List<Video>,String>{

  GetVideosUseCase({required this.videoRepository,});
  VideoRepository videoRepository;

  @override
  ResultFuture<List<Video>> call(String p) async{
    return videoRepository.getVideos(p);
  }

}
