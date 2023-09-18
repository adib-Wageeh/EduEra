import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/entities/video.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/repos/video_repo.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/use_cases/add_video_use_case.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class VideoRepositoryMock extends Mock implements VideoRepository{}

void main() {

  late VideoRepository videoRepository;
  late AddVideoUseCase addVideoUseCase;
  final tVideo = Video.empty();
  const tFailure = ServerFailure(
    error: 'unhandled exception',code: '404',
  );

  setUp(() {

    videoRepository = VideoRepositoryMock();
    addVideoUseCase = AddVideoUseCase(videoRepository: videoRepository);
    registerFallbackValue(tVideo);
  });

  test('video should be added successfully and returns right hand side',
          () async{

    // arrange
    when(()=> videoRepository.addVideo(any()))
    .thenAnswer((_) async=> const Right(null));

    // act
    final result = await addVideoUseCase.call(tVideo);

    // assert
    expect(result, const Right<dynamic,void>(null));

  });

  test('video should not be added successfully and returns left hand side',
          () async{

    // arrange
    when(()=> videoRepository.addVideo(any()))
        .thenAnswer((_) async=> const Left(tFailure));

    // act
    final result = await addVideoUseCase.call(tVideo);

    // assert
    expect(result, const Left<ServerFailure,dynamic>(tFailure));

  });

}
