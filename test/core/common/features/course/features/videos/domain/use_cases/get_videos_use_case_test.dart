
import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/entities/video.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/repos/video_repo.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/use_cases/get_videos_use_case.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class VideoRepositoryMock extends Mock implements VideoRepository{}

void main() {

  late VideoRepository videoRepository;
  late GetVideosUseCase getVideosUseCase;
  const tFailure = ServerFailure(
    error: 'unhandled exception',code: '404',
  );

  setUp(() {

    videoRepository = VideoRepositoryMock();
    getVideosUseCase = GetVideosUseCase(videoRepository: videoRepository);
  });

  test('videos should be returned successfully and returns right hand side',
          () async{

        // arrange
        when(()=> videoRepository.getVideos(any()))
            .thenAnswer((_) async=> const Right([]));

        // act
        final result = await getVideosUseCase.call('course_id');

        // assert
        expect(result, const Right<dynamic,List<Video>>([]));

      });

  test('videos should not be returned and returns left hand side',
          () async{

        // arrange
        when(()=> videoRepository.getVideos(any()))
            .thenAnswer((_) async=> const Left(tFailure));

        // act
        final result = await getVideosUseCase.call('course_id');

        // assert
        expect(result, const Left<ServerFailure,dynamic>(tFailure));

      });

}
