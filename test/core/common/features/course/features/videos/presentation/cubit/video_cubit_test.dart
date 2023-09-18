import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/features/videos/data/models/video_model.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/use_cases/add_video_use_case.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/use_cases/get_videos_use_case.dart';
import 'package:education_app/core/common/features/course/features/videos/presentation/cubit/video_cubit.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class AddVideoUseCaseMock extends Mock implements AddVideoUseCase{}

class GetVideosUseCaseMock extends Mock implements GetVideosUseCase{}


void main() {

  late GetVideosUseCase getVideosUseCase;
  late AddVideoUseCase addVideoUseCase;
  late VideoCubit videoCubit;
  final tVideo = VideoModel.empty();
  const tFailure = ServerFailure(
    error: 'error adding video to database',
    code: 404,
  );

  setUp(() {

    getVideosUseCase = GetVideosUseCaseMock();
    addVideoUseCase = AddVideoUseCaseMock();
    videoCubit = VideoCubit(addVideo: addVideoUseCase,
        getVideos: getVideosUseCase,);
    registerFallbackValue(tVideo);
  });

  tearDown(() {
    videoCubit.close();
  });

  test('ensures', () {

    expect(videoCubit.state, isA<VideoInitial>());
  });

  group('add video', () {

    blocTest<VideoCubit,VideoState>('add video successfully',
      build: (){
        when(()=> addVideoUseCase(any()))
            .thenAnswer((_) async=> const Right(null),);

        return videoCubit;
      },
      act: (cubit)async=> cubit.addVideo(tVideo),
      expect: ()=>const<VideoState>[
        AddingVideo(),
        VideoAdded()
      ],
      verify: (_){
        verify(()=>addVideoUseCase(tVideo)).called(1);
        verifyNoMoreInteractions(addVideoUseCase);
      },
    );

    blocTest<VideoCubit,VideoState>('add video unsuccessfully',
      build: (){
        when(()=> addVideoUseCase(any()))
            .thenAnswer((_) async=> const Left(tFailure),);

        return videoCubit;
      },
      act: (cubit) async=> cubit.addVideo(tVideo),
      expect: ()=><VideoState>[
        const AddingVideo(),
        VideoError(tFailure.errorMessage)
      ],
      verify: (_){
        verify(()=>addVideoUseCase(tVideo)).called(1);
        verifyNoMoreInteractions(addVideoUseCase);
      },
    );

  });

  group('get videos', () {

    blocTest<VideoCubit,VideoState>('get videos successfully',
      build: (){
        when(()=> getVideosUseCase(any()))
            .thenAnswer((_) async=> const Right([]),);

        return videoCubit;
      },
      act: (cubit)async=> cubit.getVideos('course_id'),
      expect: ()=>const<VideoState>[
        LoadingVideos(),
        VideosLoaded([])
      ],
      verify: (_){
        verify(()=>getVideosUseCase('course_id')).called(1);
        verifyNoMoreInteractions(getVideosUseCase);
      },
    );

    blocTest<VideoCubit,VideoState>('getting videos unsuccessfully',
      build: (){
        when(()=> getVideosUseCase(any()))
            .thenAnswer((_) async=> const Left(tFailure),);

        return videoCubit;
      },
      act: (cubit) async=> cubit.getVideos('course_id'),
      expect: ()=><VideoState>[
        const LoadingVideos(),
        VideoError(tFailure.errorMessage)
      ],
      verify: (_){
        verify(()=>getVideosUseCase('course_id')).called(1);
        verifyNoMoreInteractions(getVideosUseCase);
      },
    );

  });


}
