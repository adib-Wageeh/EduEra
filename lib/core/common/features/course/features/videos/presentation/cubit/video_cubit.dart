import 'package:bloc/bloc.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/entities/video.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/use_cases/add_video_use_case.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/use_cases/get_videos_use_case.dart';
import 'package:equatable/equatable.dart';

part 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  VideoCubit({
    required AddVideoUseCase addVideo,
    required GetVideosUseCase getVideos,
  })  : _addVideo = addVideo,
        _getVideos = getVideos,
        super(const VideoInitial());

  final AddVideoUseCase _addVideo;
  final GetVideosUseCase _getVideos;

  Future<void> addVideo(Video video) async {
    emit(const AddingVideo());
    final result = await _addVideo(video);
    result.fold(
          (failure) => emit(VideoError(failure.errorMessage)),
          (_) => emit(const VideoAdded()),
    );
  }

  Future<void> getVideos(String courseId) async {
    emit(const LoadingVideos());
    final result = await _getVideos(courseId);
    result.fold(
          (failure) => emit(VideoError(failure.errorMessage)),
          (videos) => emit(VideosLoaded(videos)),
    );
  }
}
