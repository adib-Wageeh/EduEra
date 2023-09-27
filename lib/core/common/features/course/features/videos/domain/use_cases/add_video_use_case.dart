import 'package:education_app/core/common/features/course/features/videos/domain/entities/video.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/repos/video_repo.dart';
import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';

class AddVideoUseCase extends FutureUseCaseWithParams<void,Video>{


  AddVideoUseCase({required this.videoRepository,});
  VideoRepository videoRepository;

  @override
  ResultFuture<void> call(Video p) async{
    return videoRepository.addVideo(p);
  }
  
}
