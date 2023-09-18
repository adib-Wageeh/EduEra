import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/features/videos/data/data_source/video_remote_data_source.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/entities/video.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/repos/video_repo.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/core/utils/typedefs.dart';

class VideoRepositoryImpl implements VideoRepository{

  VideoRepositoryImpl({required this.videoRemoteDataSource,});

  VideoRemoteDataSource videoRemoteDataSource;

  @override
  ResultFuture<void> addVideo(Video video) async{

    try {
       await videoRemoteDataSource.addVideo(video);
       return const Right(null);
    }on ServerException catch(e){
      return Left(ServerFailure(error: e.error,code: e.code,));
    }
  }

  @override
  ResultFuture<List<Video>> getVideos(String courseId) async{

    try {
      final videos = await videoRemoteDataSource.getVideos(courseId);
      return Right(videos);
    }on ServerException catch(e){
      return Left(ServerFailure(error: e.error,code: e.code,));
    }
  }


}
