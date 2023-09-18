
import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/features/videos/data/data_source/video_remote_data_source.dart';
import 'package:education_app/core/common/features/course/features/videos/data/repos/video_repository_impl.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/entities/video.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class VideoRemoteDataSourceMock extends Mock implements VideoRemoteDataSource{}

void main() {

  late VideoRemoteDataSource videoRemoteDataSource;
  late VideoRepositoryImpl videoRepositoryImpl;
  final tVideo = Video.empty();
  const tException = ServerException(
    error: 'unhandled exception',
    code: '404',
  );
  final tVideos = <Video>[];

  setUp(() {
    videoRemoteDataSource = VideoRemoteDataSourceMock();
    videoRepositoryImpl = VideoRepositoryImpl
      (videoRemoteDataSource: videoRemoteDataSource);
    registerFallbackValue(tVideo);
  });

  group('add video', () {

    test('returning right hand side (void)', () async{

      when(()=>
        videoRemoteDataSource.addVideo(any()),
      ).thenAnswer((_) async=> Future.value);

      final result = await videoRepositoryImpl.addVideo(tVideo);

      expect(result, const Right<dynamic,void>(null));
    });

    test('returning left hand side (failure)', () async{

      when(()=>
          videoRemoteDataSource.addVideo(any()),
      ).thenThrow(tException);

      final result = await videoRepositoryImpl.addVideo(tVideo);

      expect(result, Left<ServerFailure,dynamic>
        (ServerFailure.fromException(tException),),);
    });

  });

  group('get videos', () {

    test('returning right hand side (list of videos)', () async{

      when(()=>
          videoRemoteDataSource.getVideos(any()),
      ).thenAnswer((_) async=> tVideos);

      final result = await videoRepositoryImpl.getVideos('course_id');

      expect(result, Right<dynamic,List<Video>>(tVideos));
    });

    test('returning left hand side (failure)', () async{

      when(()=>
          videoRemoteDataSource.getVideos(any()),
      ).thenThrow(tException);

      final result = await videoRepositoryImpl.getVideos('course_id');

      expect(result, Left<ServerFailure,dynamic>
        (ServerFailure.fromException(tException),),);
    });

  });

}
